# -*- encoding : utf-8 -*-
require 'yaml'
require 'open3'
require 'common/workflow_service'

class Admin::PublishReleaseFilesWorker
  include Sidekiq::Worker
  def perform(id, name, server_id)

    download_server = Admin::DownloadServer.find(server_id)
    puts "Transfering game #{id} - #{name} to #{download_server.server_ip}..."

    game_file = GameFile.select('seed_digest').where('game_id=? AND status=?', id, GameFile::STATUS_TO_VERIFY).order('created_at DESC').first
    raise('game file not found') unless game_file
    cmd = "python #{Settings.tools.down_release_tool} -a #{download_server.server_ip} -i #{id} -n \"#{name}\" -s #{game_file.seed_digest} -d \"#{Settings.tools.files_root_dir}\""
    puts "----- publish command: '#{cmd}'"

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
      output = $!.to_s
      puts "error: #{output}"
    end
    
    
    msgs = output.to_s.split("\n")
    ret = false
    
    msgs.each do |msg|
      if msg.include?("[INFO ] Transfer completed!")
        ret = true
        break
      end
    end
    
    if ret
      puts "Game #{id} Transfered. result='Success'"
      ActiveRecord::Base.transaction do
        game_download_server = Admin::GameDownloadServer.find(
          :first,
          :conditions =>["game_id =? AND download_server_id = ?", id, server_id]
        )
        
        unless game_download_server
          game_download_server = Admin::GameDownloadServer.new(
            :game_id => id,
            :download_server_id => server_id
          )
        end   
  

        #new_status , rcpt, cc, msg_title, msg_body = WorkflowService.process("release_game", "STATUS_VALIDATED", "on_uploaded", {:game_name => name, :download_server => download_server.comment})
        
        game_download_server.save!
  
        #flow_err = WorkflowService.send_notification(rcpt, cc, msg_title, msg_body)
        # raise ActiveRecord::Rollback if flow_err
      end
    else
      raise output
    end
  end
end
