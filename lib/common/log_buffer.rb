# -*- encoding : utf-8 -*-

class LogBuffer
  @@line_count = 1024
  @@buffer_hash = {}
  @@lock = Mutex.new


  def self.set_line_count(line_count)
    @@line_count = line_count
  end


  # def self.start_up
    # puts "----- Inilizing LogBuffer"
# 
    # @@lock.synchronize do
      # if @@buffer_hash == nil
        # @@buffer_hash = {}
      # end
    # end
# 
    # puts "----- LogBuffer Inilized"
  # end


  def self.append(channel, msg)
    # if @@buffer_hash == nil
      # self.start_up
    # end
    
    @@lock.synchronize do
      @@buffer_hash[channel] ||= []
      
      buffer = @@buffer_hash[channel]
 
      buffer << {:timestamp=>Time.now.to_i, :msg=>msg}
      
      while buffer.size > @@line_count
        buffer.shift
      end
    end
  end
  
  
  def self.get(channel, since)
    ret = nil
    
    # if @@buffer_hash == nil
      # self.start_up
    # end
    
   	@@lock.synchronize do
      buffer = @@buffer_hash[channel]
      
      if buffer
        index = buffer.index{ |log| log[:timestamp] > since.to_i }
        
        ret = buffer.values_at(index..-1) if index
      end
    end
    
    return ret
  end
end
