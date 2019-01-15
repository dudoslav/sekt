require 'open3'

module Sekt
  class Wine
    def initialize(prefix='', architecture='win32')
      @prefix = prefix
      @architecture = architecture
      @version = `wine --version`.strip
      raise '\'wine\' is not installed' unless $?.success?
      logger.debug { "'wine' found, version: #{@version}" }
    end

    def execute(file)
      command = "WINEPREFIX=#{@prefix} WINEDLLOVERRIDES=winemenubuilder.exe=d WINEARCH=#{@architecture} wine '#{file}'"
      logger.debug { "Executing command: `#{command}`" }
      stdout, stderr, status = Open3.capture3(command)
      raise '\'wine.execute\' failed' unless status.success?
    end
  end
end
