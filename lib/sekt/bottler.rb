require 'zip'

module Sekt
  class Bottler
    def initialize(bottle, outputFile=nil)
      @inputDir = bottle.path
      @outputFile = outputFile || "#{bottle.id}.bottle"
    end

    def write()
      entries = Dir.entries(@inputDir); entries.delete("."); entries.delete("..")
      io = Zip::File.open(@outputFile, Zip::File::CREATE);

      writeEntries(entries, "", io)
      io.close();
    end

    private

    def writeEntries(entries, path, io)

      entries.each { |e|
        zipFilePath = path == "" ? e : File.join(path, e)
        diskFilePath = File.join(@inputDir, zipFilePath)
        puts "Deflating " + diskFilePath
        if  File.directory?(diskFilePath)
          io.mkdir(zipFilePath)
          subdir =Dir.entries(diskFilePath); subdir.delete("."); subdir.delete("..")
          writeEntries(subdir, zipFilePath, io)
        else
          io.get_output_stream(zipFilePath) { |f| f.puts(File.open(diskFilePath, "rb").read())}
        end
      }
    end
  end
end
