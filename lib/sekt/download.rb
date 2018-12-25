require 'open-uri'

module Sekt
  class Download
    def initialize(uri, folder='.')
      @uri = uri
      @folder = folder
    end

    def start
      download = open(@uri)
      @name = "#{download.base_uri.to_s.split('/')[-1]}"
      IO.copy_stream(download, File.join(@folder, @name))
      @name
    end
  end
end
