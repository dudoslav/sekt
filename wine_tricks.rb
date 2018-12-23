class WineTricks
  def initialize(prefix='')
    @prefix = prefix
    @version = `winetricks --version`
    raise '\'winetricks\' is not installed' unless $?.success?
    puts "'winetricks' found, version: #{@version}"
  end

  def install(dependencies)
    `WINEPREFIX=#{@prefix} winetricks install #{dependencies.join(' ')}`
  end
end
