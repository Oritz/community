# -*- encoding : utf-8 -*-
class WorkflowService
	@@workflow_hash = nil
	@@lock = Mutex.new

	
	# 处理工作流
	#
	# 参数
	#   workflow_name: 工作流名称，字符串
	#   curr_status 当前状态，字符串
	#   event: 在当前状态下发生的事件，字符串
	#   data_hash: 邮件标题和正文所需信息，见config/all_data/workflwos.yml文件中{{}}内的宏定义
	#
	# 返回值: to_status, rcpt, cc, msg_title, msg_body
	#   to_status: 新的状态，字符串，需要外部eval
	#   rcpt: 收件人，可能有多个
	#   cc: 抄送人
	#   msg_title: 邮件标题
	#   msg_body: 邮件正文	
	def self.process(workflow_name, curr_status, event, data_hash)
    if @@workflow_hash == nil
      self.start_up
    end

    workflow = @@workflow_hash[workflow_name]
    
    if workflow == nil
    	raise "Undefined workflow '#{workflow_name}'"
    end
    
	  statuses = workflow["statuses"]
	  
    if statuses == nil
    	raise "Undefined statuses for workflow '#{workflow_name}'"
    end
    
    
    status = statuses[curr_status]
    
    if status == nil
    	raise "Undefined status '#{curr_status}' for workflow '#{workflow_name}'"
    end

    event_data = status[event]
    
    if event_data == nil
    	raise "Undefined event '#{event}' for workflow '#{workflow_name}' and status '#{curr_status}'"
    end
    
    to_status = event_data["to_status"]
    rcpt = event_data["rcpt"]
    cc = event_data["cc"]
    msg_title = event_data["msg_title"]
    msg_body = event_data["msg_body"]
    

    # 替换内容
    data_hash.each_pair do |k, v|
    	msg_title = msg_title.gsub("{{#{k}}}", v.to_s)
    	msg_body = msg_body.gsub("{{#{k}}}", v.to_s)
    end

    return to_status, rcpt, cc, msg_title, msg_body
	end
	
	
	# 发送邮件
	#  参数:
	#  返回值: 错误，nil表示成功
	def self.send_notification(rcpt, cc, msg_title, msg_body)
	  err = nil
	  
	  begin
	  	SysMailer.workflow_noitification(rcpt, cc, msg_title, msg_body).deliver
    rescue
    	err = $!.to_s
    end
    
    return err
	end
	
	
	private

	def self.start_up
		@@lock.synchronize do
			if @@workflow_hash == nil	# double check
				#
				# initialize first

				@@workflow_hash = Hash.new

				workflow_data = YAML.load_file("#{Rails.root}/config/app_data/workflows.yml")
				
				if workflow_data["workflows"] == nil
					raise "Invalid workflows.yml"
				end
				
				workflow_data["workflows"].each do |workflow, definition|
					@@workflow_hash[workflow] = definition
				end
			end
		end
	end
end
