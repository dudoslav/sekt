require 'open3'

module Sekt
  class WineTricks
    def initialize(prefix, architecture='win32')
      @prefix = prefix
      @architecture = architecture
      @version = `winetricks --version`.strip
      raise '\'winetricks\' is not installed' unless $?.success?
      logger.debug { "'winetricks' found, version: #{@version}" }
    end

    def install(dependencies)
      return if dependencies.nil? || dependencies.empty?
      command = "WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks #{dependencies.join(' ')}"
      logger.debug { "Executing command: `#{command}`" }
      stdout, stderr, status = Open3.capture3(command)
      raise '\'wine_tricks.install\' failed' unless status.success?
    end

    def sandbox
      command = "WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks sandbox"
      logger.debug { "Executing command: `#{command}`" }
      stdout, stderr, status = Open3.capture3(command)
      raise '\'wine_tricks.sandbox\' failed' unless status.success?
    end
  end
end
