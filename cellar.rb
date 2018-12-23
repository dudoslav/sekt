require 'yaml'

class Cellar
  CELLAR_PATH = File.join(ENV['HOME'], '.cellar').freeze

  attr_reader :bottles

  def initialize
    Dir.mkdir(CELLAR_PATH) unless Dir.exists?(CELLAR_PATH)
    bottle_dirs = Dir.glob(File.join(CELLAR_PATH, '*')).select { |f| File.directory? f }
    @bottles = bottle_dirs.map { |bd| Bottle.load(bd, YAML.load_file(File.join(bd, 'bottle.yml'))) }
    puts 'Cellar loaded'
  end

  def save(bottle)
    # TODO: implement
  end
end
