class WineTricks
  def initialize(prefix='')
    @prefix = prefix
    @version = `winetricks --version`
    raise '\'winetricks\' is not installed' unless $?.success?
    puts "'winetricks' found, version: #{@version}"
  end

  def install(dependencies)
    return if dependencies.empty?
    puts "executing: `WINEPREFIX=#{@prefix} winetricks install #{dependencies.join(' ')}`"
    `WINEPREFIX=#{@prefix} winetricks install #{dependencies.join(' ')}`
    # raise '\'wine_tricks.install\' failed' unless $?.success?
  end
end
