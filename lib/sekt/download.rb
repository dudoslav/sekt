require 'net/http'

module Sekt
  class Download
    def initialize(source, folder='.')
      @uri = URI.parse(source)
      @folder = folder
    end

    def start
      fetch
      @name
    end

    def fetch(limit = 10)
      raise 'Too many HTTP redirects' if limit == 0

      Net::HTTP.start(@uri.host) do |http|
        http.request_get(@uri.request_uri) do |resp|
          handle_response(resp)
        end
      end
    end

    def handle_response(resp)
      case resp
      when Net::HTTPRedirection then
        @uri = URI.parse(resp['location'])
        fetch(limit - 1)
      when Net::HTTPSuccess then
        ok_response(resp)
      else raise "Download failed: #{resp.message}"
      end
    end

    def response_filename(resp)
      return unless resp['content-disposition']

      resp['content-disposition']
        .map { |h| h.match(/filename=(\"?)(.+)\1/)[2] }
        .compact.first
    end

    def ok_response(resp)
      @name = response_filename(resp) || File.basename(@uri.path)
      @path = File.join(@folder, @name)

      File.open(@path, 'w') do |f|
        resp.read_body do |segment|
          f.write(segment)
        end
      end
    end
  end
end
