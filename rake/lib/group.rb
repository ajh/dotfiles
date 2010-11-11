require File.join(File.dirname(__FILE__) + '/config_file')

module DotFiles
  class Group
    attr_reader :name
    attr_reader :files

    def initialize(directory)
      @name = File.basename(directory)
      @files = []
      Find.find(directory) do |f| 
        File.file?(f) && !hidden?(f) or next
        @files << ConfigFile.new(f, :project_dir => directory)
      end
    end

    def <=>(other)
      name <=> other.name
    end

    def install(install_dir)
      @files.each {|f| f.install install_dir}
    end

    def inspect
      "#<#{self.class.to_s}: @name=#{@name.inspect} @files=#{@files.inspect}>"
    end

    private

      def hidden?(filename)
        File.basename(filename).match %r/^\./
      end
  end
end
