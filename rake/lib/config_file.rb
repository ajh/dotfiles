require 'fileutils'
require File.join(File.dirname(__FILE__) + '/dot_files')

# A dot file represents a config file that is included in this project. 
#
# It can be installed to the home directory (or to 'home_dir'). 
#
# To avoid having hidden files in the git project, a file that gets installed
# as .vimrc for example appears as dot_vimrc in the project dir.
module DotFiles
  class ConfigFile
    attr_reader :project_file, :project_dir, :install_dir, :install_file

    def initialize(project_file, options = {})
      @project_file = project_file
      @project_dir = options[:project_dir] || File.join(File.dirname(__FILE__), '/../../home')
    end

    def install(install_dir = ENV['HOME'])
      install_file = @project_file.sub(@project_dir, install_dir).gsub(%r/(\W|^)dot_(\w+)/, '\1.\2')
      mkdir_p File.dirname(install_file)
      ln_s @project_file, install_file
    end

    def inspect
      "#<#{self.class.to_s} #{@project_file.inspect}>"
    end

    private 

      def mkdir_p(dir)
        return if File.directory?(dir)
        puts "mkdir_p #{dir}" if DotFiles.debug
        FileUtils.mkdir_p dir
      end

      def ln_s(src, dest)
        src = File.expand_path src
        if File.symlink?(dest) and File.readlink(dest) == src
          return
        elsif File.file?(dest)
          if DotFiles.force
            FileUtils.rm dest
          else
            raise RuntimeError.new("file #{dest} already exists") if File.file?(dest)
          end
        end

        puts "ln_s #{src} #{dest}" if DotFiles.debug
        FileUtils.ln_s src, dest
      end
  end
end
