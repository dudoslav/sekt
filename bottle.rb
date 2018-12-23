require_relative 'cellar'
require_relative 'wine'
require_relative 'wine_tricks'

class Bottle
  WINE_PREFIX_NAME = 'windows'.freeze

  attr_reader :id, :name, :description, :source, :dependencies, :path, :wine_prefix

  def initialize(id, name, description, source, dependencies)
    @id = id
    @name = name
    @description = description
    @source = source
    @dependencies = dependencies

    @path = File.join(Cellar::CELLAR_PATH, @id)
    @wine_prefix = File.join(@path, WINE_PREFIX_NAME)
  end

  def self.load(id, hash)
    Bottle.new(id,
               hash['name'],
               hash['description'],
               hash['source'],
               hash['dependencies'])
  end

  def wine
    Wine.new(wine_prefix)
  end

  def wine_tricks
    WineTricks.new(wine_prefix)
  end

  def inside(&block)
    Dir.chdir(&block)
  end
end
