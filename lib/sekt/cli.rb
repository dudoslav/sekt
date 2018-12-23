require 'thor'
require 'net/http'
require 'fileutils'
require 'sekt/cellar'

module Sekt
  class CLI < Thor
    desc 'install FILE', 'Installs wine program'
    option :source, type: :string, desc: 'Local source'
    def install(file)
      cellar = Cellar.new

      bottle_yaml = YAML.load_file(file)
      bottle = cellar.create_bottle(bottle_yaml)

      wine_tricks = bottle.wine_tricks
      wine_tricks.install(bottle.dependencies)

      source_path = File.expand_path(options[:source]) if options[:source]
      wine = bottle.wine
      bottle.inside do
        if options[:source]
          FileUtils.cp(source_path, 'binary.exe')
        else
          download(bottle.source)
        end
        wine.execute('binary.exe')
      end
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

    desc 'remote ID', 'Removes bottle with given id'
    def remove(id)
      Cellar.new.remove(id)
    end

    desc 'clean', 'Deletes all bottles'
    def clean
      Cellar.new.clean
    end

    map pop: :install
    map cellar: :list
    map bottles: :list

  private

    def download(source)
      puts "downloading: #{source}"

      uri = URI.parse(source)
      Net::HTTP.start(uri.host) do |http|
          resp = http.get(uri.path)
          open("binary.exe", "wb") do |file|
              file.write(resp.body)
          end
      end
    end
  end
end
