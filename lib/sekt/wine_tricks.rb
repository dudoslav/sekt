module Sekt
  class WineTricks
    def initialize(prefix='', architecture='win32')
      @prefix = prefix
      @architecture = architecture
      @version = `winetricks --version`
      raise '\'winetricks\' is not installed' unless $?.success?
      puts "'winetricks' found, version: #{@version}"
    end

    def install(dependencies)
      return if dependencies.empty?
      puts "executing: `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks #{dependencies.join(' ')}`"
      `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks #{dependencies.join(' ')}`
      raise '\'wine_tricks.install\' failed' unless $?.success?
    end

    def sandbox
      puts 'creating sandbox'
      `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks sandbox`
      raise '\'wine_tricks.sandbox\' failed' unless $?.success?
    end
  end
end
