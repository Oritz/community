# -*- encoding : utf-8 -*-

require "net/http"
require "logger"

class RemoteLogger < Logger
	def initialize(logger_url, channel='default', other_logger=nil)
		@remote_url = URI.parse(logger_url)
		@channel = channel

    @other_logger = other_logger
	end
	
	def set_channel(channel)
		@channel = channel
	end

	def debug(msg)
		@other_logger.debug(msg) if @other_logger
		post_to_server("[DEBUG] #{msg}") if debug?()
	end
	
	
	def info(msg)
		@other_logger.info(msg) if @other_logger
		post_to_server("[INFO] #{msg}") if info?()
	end
	
	
	def warn(msg)
		@other_logger.warn(msg) if @other_logger
		post_to_server("[WARN] #{msg}") if warn?()
	end
	
	
	def error(msg)
		@other_logger.error(msg) if @other_logger
		post_to_server("[ERROR] #{msg}") if error?()
	end
	
  def fatal(msg)
    @other_logger.fatal(msg) if @other_logger
    post_to_server("[ERROR] #{msg}") if fatal?()
  end
	
	private
	
	def post_to_server(msg)
		data = "channel=#{@channel}&msg=#{msg}"
    @http_handler = Net::HTTP.new(@remote_url.host, @remote_url.port)
		@http_handler.post(@remote_url.path, data, nil)
	end
end
