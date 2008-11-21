require File.join(File.dirname(__FILE__) + '/config_file')

module DotFiles
  class Group
    attr_reader :name
    attr_reader :files

    def initialize(directory)
      @name = File.basename(directory)
      @files = []
      Find.find(directory) { |f| @files << ConfigFile.new(f, :project_dir => directory) if File.file? f }
    end

    def <=>(other)
      name <=> other.name
    end

    def install(install_dir)
      @files.each {|f| f.install install_dir}
    end

  end
end
