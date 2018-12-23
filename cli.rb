require 'thor'
require_relative 'sekt'
require_relative 'cellar'

class CLI < Thor
  desc 'install FILE', 'installs wine program'
  def install(file)
    # TODO: implement
  end

  desc 'list', 'lists installed bottles'
  def list
    Cellar.new.bottles.each do |bottle|
      puts '---------------BOTTLE----------------'
      puts "name = #{bottle.name}"
      puts "description = #{bottle.description}"
      puts "wine_prefix = #{bottle.wine_prefix}"
      puts '-------------------------------------'
    end
  end

  map pop: :install
  map cellar: :list
  map bottles: :list
end

CLI.start(ARGV)
