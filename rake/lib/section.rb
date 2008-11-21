require 'fileutils'

# A Section is an installer for a section of configs included in the dotfiles
# project. A section is created for each application and is named after the
# application. 
#
# This depends on the config files following common unix
# conventions. For example: ~/.vimrc would be recognized to belong to a 'vim'
# section, as would .vim/plugins/ft.vim.
# 
# The conventions are ~/.#{name}rc or ~/#{name}/path/to/file
#
# When installed, the configs in home will be symlinked back to the git project
# so that git controls them.
class Section
  @debug = true

  class << self
    attr_accessor :debug
  end

  # create an array of sections from a list of filenames.
  def self.create_from_files(files)
    sections = {}

    files.each do |file|
      case file
      when %r"dot_(\w+)rc$"
        name = $1
        (sections[name] ||= new(:name => name)).files << file
      when %r"dot_(\w+)/(.*)$"
        name = $1
        (sections[name] ||= new(:name => name)).files << file
      end
    end


    sections.values
  end

  attr_reader :name
  attr_reader :files

  def initialize(options = {})
    @name = options[:name]
    @files = options[:files] || []
    @project_dir = options[:project_dir] || File.expand_path(File.join(File.dirname(__FILE__), '/../../home'))
  end

  def <=>(other)
    name <=> other.name
  end

  def install(directory = ENV['HOME'])
    @files.each do |file|
      dest_file = file.sub(@project_dir, directory).gsub(%r/(\W)dot_(\w+)/, '\1.\2')

      unless File.dirname(dest_file) == directory
        mkdir_p File.dirname(dest_file)
      end
      ln_s file, dest_file
    end

    true
  end

  private 

    def mkdir_p(dir)
      unless File.directory?(dir)
        puts "mkdir_p #{dir}" if self.class.debug
        FileUtils.mkdir_p dir
      end
    end

    def ln_s(src, dest)
      unless File.symlink?(dest) and File.readlink(dest) == src
        puts "ln_s #{src} #{dest}" if self.class.debug
        FileUtils.ln_s src, dest
      end
    end
end
