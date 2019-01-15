require 'thor'

module Sekt
  module CLI
    class Bottle < Thor
      include GetBottle

      desc 'start ID', 'Start default bottle executable'
      def start(id)
        get_bottle!(id).start
      end

      desc 'execute ID EXECUTABLE', 'Execute program inside bottle'
      def execute(id, executable)
        get_bottle!(id).wine.start(executable)
      end

      desc 'rename OLD NEW', 'Rename bottle'
      def rename(old, new)
        get_bottle!(old)
        Cellar.inside { File.rename(old, new) }
      end

      desc 'remove ID', 'Remove bottle with given id'
      def remove(id)
        get_bottle!(id)
        return unless yes?("Are you sure you want to delete bottle #{id}?")
        Cellar.new.remove(id)
      end

      desc 'clean', 'Delete all bottles'
      def clean
        return unless yes?("Are you sure you want to delete all bottles?")
        Cellar.new.clean
      end

      desc 'list', 'List installed bottles'
      def list
        Cellar.new.bottles.each { |b| puts b.pp }
      end

      desc 'print ID', 'Print detailed info about bottle'
      def print(id)
        bottle = get_bottle!(id)
        puts bottle.pp
        puts "\tDependencies:"
        bottle.dependencies.each { |d| puts "\t\t- #{d}"}
      end

      desc 'install-lib ID *LIBS', 'Install libraries from winetricks'
      def install_lib(id, *libs)
        bottle = get_bottle!(id)

        bottle.install_libs(libs)

        cellar.update_bottle(bottle)
      end

      # TODO: Implement in future
      #desc 'import FILE', 'Import bottle'
      #def import(file) # *.bottle file
      #end
      #
      #desc 'export ID [FILE]', 'Export bottle'
      #def export(id, file="#{id}.bottle")
      #end
    end
  end
end
