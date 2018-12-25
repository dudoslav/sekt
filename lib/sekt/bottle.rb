require 'sekt/cellar'
require 'sekt/wine'
require 'sekt/wine_tricks'

module Sekt
  class Bottle
    WINE_PREFIX_NAME = 'windows'.freeze

    attr_reader :id, :name, :description, :architecture, :path, :wine_prefix, :executable
    attr_accessor :source, :dependencies

    def initialize(id, name, description, source, architecture, dependencies, executable)
      @id = id
      @name = name
      @architecture = architecture || 'win32'
      @description = description
      @source = source
      @dependencies = dependencies || []
      @executable = executable

      @path = File.join(Cellar::CELLAR_PATH, @id)
      @wine_prefix = File.join(@path, WINE_PREFIX_NAME)
    end

    def self.load(id, hash)
      Bottle.new(id,
                 hash['name'],
                 hash['description'],
                 hash['source'],
                 hash['architecture'],
                 hash['dependencies'],
                 hash['executable'])
    end

    def wine
      Wine.new(wine_prefix, architecture)
    end

    def wine_tricks
      WineTricks.new(wine_prefix, architecture)
    end

    def inside(&block)
      Dir.chdir(path, &block)
    end

    def start
      wine.start(executable)
    end

    def to_h
      { name: name,
        description: description,
        source: source,
        architecture: architecture,
        dependencies: dependencies,
        executable: executable }
    end
  end
end
