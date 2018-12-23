require 'thor'
require 'net/http'
require_relative 'cellar'

class CLI < Thor
  desc 'install FILE', 'installs wine program'
  def install(file)
    cellar = Cellar.new

    bottle_yaml = YAML.load_file(file)
    bottle = cellar.create_bottle(bottle_yaml)

    wine_tricks = bottle.wine_tricks
    wine_tricks.install(bottle.dependencies)

    wine = bottle.wine
    bottle.inside do
      download(bottle.source)
      wine.execute('binary.exe')
    end
  end

  desc 'start ID', 'starts default bottle executable'
  def start(id)
    bottle = Cellar.new.get_bottle(id)
    return unless bottle

    bottle.start
  end

  desc 'list', 'lists installed bottles'
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

  desc 'remote ID', 'removes bottle with given id'
  def remove(id)
    Cellar.new.remove(id)
  end

  desc 'clean', 'deletes all bottles'
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

CLI.start(ARGV)
