# -*- encoding : utf-8 -*-
require 'digest/sha1'
require 'yaml'
require 'open3'
require 'common/workflow_service'

class Admin::PreReleaseWorker
  include Sidekiq::Worker

  def perform(game_file_id)
    puts "----- Start PreReleaseWorker"

    err = nil
    game_name = nil

    1.times do
      game_id = nil
      crypt_type = nil
      exe_path_name = ""
      new_game_file = nil
      
      ActiveRecord::Base.transaction do
        new_game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_NEW).first

        if !new_game_file
          err = "ERRORS.ERR_GAME_FILE_NOT_FOUND"
          break
        end
        
        new_game_file.process_start_time = Time.now
        new_game_file.save!
        
        game_id = new_game_file.game_id
        crypt_type = new_game_file.crypt_type
        exe_path_name = new_game_file.exe_path_name
      end

      if crypt_type != Launcher::CRYPT_TYPE_EXTERNAL
        # 生成ame_key和game_key_iv
        arr = []
        i =  GameFile::KEY_LEN

        while i > 0
          arr.push(rand(256))
          i -=1
        end

        game_key = arr.pack("c*").unpack('H*').join

        arr = []
        i =  GameFile::KEY_LEN

        while i > 0
          arr.push(rand(256))
          i -=1
        end

        game_key_iv = arr.pack("c*").unpack('H*').join

        key_digest =  Digest::SHA1.hexdigest("#{game_key}#{game_key_iv}")

        bak_path_name = exe_path_name.gsub("files", "raw_files")
        
        if !File.exist?(bak_path_name)
          File.open(bak_path_name, 'wb'){|t| t.write(File.open(exe_path_name, "rb").read)}
        end
        
        # 加密
        puts "Encrypting game #{game_id}..."
        cmd = eval(Settings.tools.entrypt_tool_cmds[crypt_type])

        output = ""        
        begin
          stdin, stdoe = Open3.popen2e("#{cmd}")
          stdin.close
          
          while !stdoe.closed?
            line = stdoe.gets
            break unless line
            puts line
            output += line
          end
          
          stdoe.close if !stdoe.closed?
        rescue
          err = $!.to_s
          break
        end

        msg = output.to_s.split("\n")

        puts "Game #{game_id} has been encrypted. result='#{msg[0]}'"

        if msg[0] != "SUCCESS"
          err = output
          break
        end

        ActiveRecord::Base.transaction do
          new_game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_NEW).first
          
          new_game_file.game_key = game_key
          new_game_file.game_key_iv = game_key_iv
          new_game_file.key_digest = key_digest
          new_game_file.save!
        end
      end

      # release tool参数：<game_id, game_name, game_dir, patch_ver, release_dir, parent_id, parent_name, work_dir>
      game = Game.select(
          'games.name AS name, games.english_name AS english_name, parent_id, parent.english_name AS parent_name'
      ).joins(
          'LEFT JOIN game_dlcs ON game_dlcs.id=games.id LEFT JOIN games AS parent ON parent.id=game_dlcs.parent_id'
      ).where('game_id=?', game_id).first

      game_name = game.english_name
      parent_cmd = nil
      if game.parent_id
        parent_cmd = "--parent_id=#{game.parent_id} --parent_name=\"#{game.parent_name}\""          
      end
      
      puts "Processing game #{game_id} - #{game.english_name}---belongs to#{game.parent_name}..."
      
      cmd = "#{Settings.tools.release_tool} --game_id=#{game_id} --game_name=\"#{game_name}\" --game_dir=\"#{game_name}\" --patch_ver=#{new_game_file.patch_ver} --release_dir=\"#{new_game_file.file_dir}\" --work_dir=\"#{Settings.tools.files_root_dir}\" #{parent_cmd}"

      output = ""        
      begin
        stdin, stdoe = Open3.popen2e("#{cmd}")
        stdin.close

        while !stdoe.closed?
          line = stdoe.gets
          break unless line
          puts line
          output += line
        end
        
        stdoe.close if !stdoe.closed?
      rescue
        puts $!.to_s
        puts $!.backtrace
        err = $!.to_s
        break
      end

      msg = {}
      begin
        msg = JSON.parse(output)
      rescue
        puts $!.to_s
        puts $!.backtrace
        err = $!.to_s
        break
      end
      
      release_ret = msg["result"]
      release_digest = msg["digest"]
      err_ret = msg["err"]
      
      if release_ret
        puts "Game seed successfully made..."
        puts "verifying the digest..."
        seed_content_path = nil
        if new_game_file.file_dir == "initial"
          seed_content_path = Settings.tools.file_meta_dir + "/#{game.english_name}.mf"
        else
          seed_content_path = Settings.tools.file_meta_dir + "/#{game.english_name}_patch_#{new_game_file.patch_ver}.mf"
        end
        
        seed_content = nil
        File.open(seed_content_path, "rb"){|s| seed_content = s.read}
        file_size = msg["size"]
        real_digest = Digest::SHA1.hexdigest(seed_content)
        
        if release_digest == real_digest
          ActiveRecord::Base.transaction do
            new_game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_NEW).first
            new_game_file.seed_content = seed_content
            new_game_file.seed_digest = real_digest
            new_game_file.file_size = file_size
            new_game_file.save!
          end   
          puts "Success!"
        else
          err = "Failed, digest is not match."
          break
        end
      else
        err = err_ret || output
        break
      end
    end
    

    ActiveRecord::Base.transaction do
      new_game_file = GameFile.lock(true).where('id=? AND status=?', game_file_id, GameFile::STATUS_NEW).first
      
      if new_game_file
        if err
          # 出错 发送种子制作失败邮件
          #new_status, rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_NEW", "on_failed", {:game_name => game_name, :game_file_id => new_game_file.id})
          new_game_file.process_finish_time = Time.now
          new_game_file.process_result = err
          new_game_file.save!
          
          #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
          # raise ActiveRecord::Rollback if flow_err
        else
          #成功并发送通知邮件
          #new_status, rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_NEW", "on_pass", {:game_name => game_name, :game_file_id => new_game_file.id, :release_msg => t('')})
          new_game_file.process_finish_time = Time.now
          new_game_file.status = GameFile::STATUS_TO_VERIFY   #eval("GameFile::#{new_status}")
          new_game_file.save!
          
          #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
          # raise ActiveRecord::Rollback if flow_err
        end
      end
    end
    
    if err && (err.length > 0)
      raise err
    end
  end
end
