class Wine
  def initialize(prefix='')
    @prefix = prefix
    @version = `wine --version`
    raise '\'wine\' is not installed' unless $?.success?
    puts "'wine' found, version: #{@version}"
  end

  def execute(file)
    puts "executing: `WINEPREFIX=#{@prefix} wine #{file}`"
    `WINEPREFIX=#{@prefix} wine #{file}`
    raise '\'wine.execute\' failed' unless $?.success?
  end
end
