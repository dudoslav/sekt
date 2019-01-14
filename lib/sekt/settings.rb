require 'settingslogic'

module Sekt
  class Settings < Settingslogic
    CONFIG_FILE = 'sekt.yml'.freeze

    source "#{ENV['HOME']}/.sekt/#{CONFIG_FILE}" \
      if File.exist?("#{ENV['HOME']}/.sekt/#{CONFIG_FILE}")

    source "/etc/sekt/#{CONFIG_FILE}" \
      if File.exist?("/etc/sekt/#{CONFIG_FILE}")

    source "#{File.dirname(__FILE__)}/../../config/#{CONFIG_FILE}"
  end
end
