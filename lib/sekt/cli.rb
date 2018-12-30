require 'thor'
require 'fileutils'
require 'pathname'
require 'uri'
require 'sekt/cellar'
require 'sekt/download'
require 'sekt/bottler'

module Sekt
  class CLI < Thor
    desc 'install FILE', 'Installs wine program'
    option :source, type: :string, desc: 'Local source'
    def install(file)
      cellar = Cellar.new

      bottle_yaml = YAML.load_file(file)
      bottle = cellar.create_bottle(bottle_yaml)

      wine_tricks = bottle.wine_tricks
      wine_tricks.sandbox
      wine_tricks.install(bottle.dependencies)

      bottle.source = File.expand_path(options[:source]) if options[:source]
      wine = bottle.wine
      bottle.inside do
        wine.execute(get_source(bottle))
      end

      cellar.update_bottle(bottle)
    end

    desc 'start ID', 'Starts default bottle executable'
    def start(id)
      bottle = Cellar.new.get_bottle(id)
      return unless bottle

      bottle.start
    end

    desc 'list', 'Lists installed bottles'
    def list
      Cellar.new.bottles.each do |bottle|
        puts "---------------BOTTLE(#{bottle.id})------"
        puts "name = #{bottle.name}"
        puts "description = #{bottle.description}"
        puts "wine_prefix = #{bottle.wine_prefix}"
        puts "architecture = #{bottle.architecture}"
        puts "executable = #{bottle.executable}"
        puts '-------------------------------------'
      end
    end

    desc 'print ID', 'Prints detailed bottle information'
    def print(id)
      cellar = Cellar.new
      bottle = cellar.get_bottle(id)
      return unless bottle

      puts "---------------(#{bottle.id})---------------"
      puts "name = #{bottle.name}"
      puts "description = #{bottle.description}"
      puts "source = #{bottle.source}"
      puts "wine_prefix = #{bottle.wine_prefix}"
      puts "path = #{bottle.path}"
      puts "architecture = #{bottle.architecture}"
      puts "executable = #{bottle.executable}"
      puts "dependencies:"
      bottle.dependencies.each { |d| puts "\t- #{d}" }
      puts '-------------------------------------'
    end

    desc 'update ID *DEPS', 'Updates existing bottle with given dependencies'
    def update(id, *deps)
      cellar = Cellar.new
      bottle = cellar.get_bottle(id)
      return unless bottle

      bottle.wine_tricks.install(deps)
      bottle.dependencies << deps

      cellar.update_bottle(bottle)
    end

    desc 'export ID', 'Exports bottle'
    def export(id)
      cellar = Cellar.new
      bottle = cellar.get_bottle(id)
      return unless bottle

      bottler = Bottler.new(bottle)
      bottler.write
    end

    desc 'import FILE', 'Imports bottle'
    def import(file)
    end

    desc 'remote ID', 'Removes bottle with given id'
    def remove(id)
      Cellar.new.remove(id)
    end

    desc 'clean', 'Deletes all bottles'
    def clean
      Cellar.new.clean
    end

  private

    def get_source(bottle)
      if bottle.source =~ URI::regexp
        return Download.new(bottle.source).start
      end

      source_path = Pathname.new(bottle.source)
      if source_path
        FileUtils.cp(source_path, '.')
        return source_path.basename
      end

      raise 'Failed to retrieve bottle.source'
    end
  end
end
