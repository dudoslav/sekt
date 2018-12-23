require 'securerandom'
require_relative 'cellar'

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

  def self.load(bottle_path, hash)
    # TODO: implement
  end
end
