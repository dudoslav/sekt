require 'thor'

module Sekt
  module CLI
    class Recipe < Thor
      include GetBottle

      desc 'install [FILE]', 'Install wine program from recipe into bottle'
      def install(file='bottle.yml')
        @cellar = Cellar.new

        bottle_yaml = YAML.load_file(file)
        bottle = @cellar.create_bottle(bottle_yaml)

        wine_tricks = bottle.wine_tricks
        wine_tricks.sandbox
        wine_tricks.install(bottle.dependencies)

        wine = bottle.wine
        bottle.inside_wine do
          wine.execute("C:\\#{get_source(bottle)}")
        end

        @cellar.update_bottle(bottle)
      end

      desc 'export ID', 'Export recipe from bottle'
      def export(id)
        File.write("#{id}.yml", get_bottle!(id).to_h.to_yaml)
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
end
