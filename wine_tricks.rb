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
    puts "executing: `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks install #{dependencies.join(' ')}`"
    `WINEPREFIX=#{@prefix} WINEARCH=#{@architecture} winetricks install #{dependencies.join(' ')}`
    # raise '\'wine_tricks.install\' failed' unless $?.success?
  end
end
