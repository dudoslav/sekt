require 'thor'

module Sekt
  module CLI
    class Recipe < Thor
      desc 'install [FILE] [ID]', 'Install wine program from recipe into bottle'
      def install(file='bottle.yml', id)
      end

      desc 'export ID', 'Export recipe from bottle'
      def export(id)
      end
    end
  end
end
