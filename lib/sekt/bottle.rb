require 'sekt/cellar'
require 'sekt/wine'
require 'sekt/wine_tricks'

module Sekt
  class Bottle
    WINE_PREFIX_NAME = 'windows'.freeze
    REQUIRED_ATTRIBUTES = %w{id name source}.freeze
    OPTIONAL_ATTRIBUTES = %w{architecture description dependencies executable}.freeze
    ATTRIBUTES = REQUIRED_ATTRIBUTES + OPTIONAL_ATTRIBUTES

    attr_reader(*ATTRIBUTES)
    attr_reader :path, :wine_prefix

    def check_args!(hash)
      diff = REQUIRED_ATTRIBUTES - hash.keys
      raise "Some required bottle attributes are missing: #{diff}" unless diff.empty?
    end

    def initialize(hash)
      check_args!(hash)

      ATTRIBUTES.each { |attr| instance_variable_set("@#{attr}", hash[attr]) }

      @path = File.join(Cellar::CELLAR_PATH, @id)
      @wine_prefix = File.join(@path, WINE_PREFIX_NAME)
    end

    def self.load(id, hash)
      hash['id'] = id
      Bottle.new(hash)
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

    def inside_wine(&block)
      Dir.chdir(File.join(wine_prefix, 'drive_c'), &block)
    end

    def start
      wine.execute(executable)
    end

    def install_libs(libs)
      wine_tricks.install(libs)
      @dependencies + libs
    end

    def to_h
      ATTRIBUTES.each_with_object({}) { |attr, hash| hash[attr] = instance_variable_get("@#{attr}") }
    end

    def pp
      %(
        Bottle___________________________________________________
        |NAME: #{name}
        |ID: #{id}
        |PATH: #{path}
        |WINE_PREFIX: #{wine_prefix}
        |________________________________________________________

          Description:
            #{description}
          Source: #{source}
          Executable: #{executable}
          Architecture: #{architecture}
      )
    end
  end
end
