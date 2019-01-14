require 'thor'

module Sekt
  module CLI
    class Bottle < Thor
      desc 'start ID', 'Start default bottle executable'
      def start(id)
      end

      desc 'execute ID EXECUTABLE', 'Execute program inside bottle'
      def execute(id, executable)
      end

      desc 'rename OLD NEW', 'Rename bottle'
      def rename(old, new)
      end

      desc 'remove ID', 'Remove bottle with given id'
      def remove(id)
      end

      desc 'clean', 'Delete all bottles'
      def clean
      end

      desc 'list', 'List installed bottles'
      def list
      end

      desc 'print ID', 'Print detailed info about bottle'
      def print(id)
      end

      desc 'install-lib ID *LIBS', 'Install libraries from winetricks'
      def install_lib(id, *libs)
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
