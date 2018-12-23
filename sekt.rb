require 'yaml'
require 'net/http'
require_relative 'bottle'
require_relative 'wine'
require_relative 'wine_tricks'

class Sekt
  def install(file)
    yaml = YAML.load_file(file)
    bottle = Bottle.create(yaml)
    wine = Wine.new(bottle.wine_prefix)
    wine_tricks = WineTricks.new(bottle.wine_prefix)
    wine_tricks.install(bottle.dependencies)
    download(bottle.source)
    wine.execute('binary.exe')
  end

  def download(source)
    uri = URI.parse(source)
    Net::HTTP.start(uri.host) do |http|
        resp = http.get(uri.path)
        open("binary.exe", "wb") do |file|
            file.write(resp.body)
        end
    end
  end
end
