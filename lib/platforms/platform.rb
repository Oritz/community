module Platform
  module Network
    def get(url)
      return nil unless url
      url = url.strip
      header = "http://"
      return nil if header != url[0..header.length-1]

      uri = URI(url)
      response = Net::HTTP.get_response(uri)

      case response
      when Net::HTTPSuccess then
        begin
          JSON.parse(response.body)
        rescue
          nil
        end
      else
        nil
      end
    end
  end
end
