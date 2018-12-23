module Sekt
  class Wine
    def initialize(prefix='', architecture='win32')
      @prefix = prefix
      @architecture = architecture
      @version = `wine --version`
      raise '\'wine\' is not installed' unless $?.success?
      puts "'wine' found, version: #{@version}"
    end

    def execute(file)
      puts "executing: `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} wine #{file}`"
      `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} wine #{file}`
      raise '\'wine.execute\' failed' unless $?.success?
    end

    def start(win_path)
      puts "WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} wine '#{win_path}'"
      exec("WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} wine '#{win_path}'")
    end
  end
end
