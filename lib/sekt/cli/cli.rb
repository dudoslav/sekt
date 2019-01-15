require 'thor'
require 'yell'

module Sekt
  module CLI
    class CLI < Thor
      def initialize(*args)
        super
        init_logger
      end

      desc 'version', 'Print Sekt version'
      def version
        puts Sekt::VERSION
      end

      desc 'bottle SUBCOMMAND ...ARGS', 'Manage bottles'
      subcommand 'bottle', Bottle

      desc 'recipe SUBCOMMAND ...ARGS', 'Manage recipes'
      subcommand 'recipe', Recipe

    private

      def init_logger
        Yell.new :stdout, name: Object, level: Settings.logging_level
        Object.send :include, Yell::Loggable
      end
    end
  end
end
