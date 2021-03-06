require 'yaml'
require 'securerandom'
require 'fileutils'
require 'sekt/bottle'

module Sekt
  class Cellar
    CELLAR_PATH = File.expand_path(Sekt::Settings.cellar_location).freeze

    attr_reader :bottles

    def self.inside(&block)
      Dir.chdir(CELLAR_PATH, &block)
    end

    def initialize
      Dir.mkdir(CELLAR_PATH) unless Dir.exists?(CELLAR_PATH)
      bottle_dirs = Dir.glob(File.join(CELLAR_PATH, '*')).select { |f| File.directory? f }
      @bottles = bottle_dirs.map { |bd| Bottle.load(File.basename(bd), YAML.load_file(File.join(bd, 'bottle.yml'))) }
      logger.debug('Cellar loaded')
    end

    def create_bottle(hash, id=SecureRandom.urlsafe_base64(6))
      bottle_path = File.join(CELLAR_PATH, id)
      Dir.mkdir(bottle_path)
      File.write(File.join(bottle_path, 'bottle.yml'), hash.to_yaml)
      bottle = Bottle.load(id, hash)
      @bottles << bottle
      bottle
    end

    def update_bottle(bottle)
      File.write(File.join(bottle.path, 'bottle.yml'), bottle.to_h.to_yaml)
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
end
