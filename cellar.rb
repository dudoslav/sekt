require 'yaml'
require 'securerandom'
require 'fileutils'
require_relative 'bottle'

class Cellar
  CELLAR_PATH = File.join(ENV['HOME'], '.cellar').freeze

  attr_reader :bottles

  def initialize
    Dir.mkdir(CELLAR_PATH) unless Dir.exists?(CELLAR_PATH)
    bottle_dirs = Dir.glob(File.join(CELLAR_PATH, '*')).select { |f| File.directory? f }
    @bottles = bottle_dirs.map { |bd| Bottle.load(File.basename(bd), YAML.load_file(File.join(bd, 'bottle.yml'))) }
    puts 'Cellar loaded'
  end

  def create_bottle(hash)
    id = SecureRandom.urlsafe_base64(6)
    bottle_path = File.join(CELLAR_PATH, id)
    Dir.mkdir(bottle_path)
    File.write(File.join(bottle_path, 'bottle.yml'), hash.to_yaml)
    bottle = Bottle.load(id, hash)
    @bottles << bottle
    bottle
  end

  def remove(id)
    bottle = get_bottle(id)
    remove_bottle(bottle)
  end

  def remove_bottle(bottle)
    FileUtils.rm_rf(bottle.path) if bottle
  end

  def get_bottle(id)
    bottles.find { |b| b.id == id }
  end

  def clean
    bottles.each { |b| remove_bottle(b) }
  end
end
