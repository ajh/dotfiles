require 'pathname'
require 'find'

module DotFiles
  class DotFile
    # Returns a list of dot files for the given cookbook. Dotfiles are found in the 'files' folder of the cookbook and automatically translated into
    def self.find(cookbook_name)
      paths = []

      Find.find CONFIG.root_path.join('cookbooks', cookbook_name, 'dotfiles') do |path|
        path = Pathname.new path

        path.file? or next
        path.basename.to_s[0] != '.' or next # ignore real dotfiles

        paths << DotFile.new(path)
      end

      paths
    end

    def initialize(cookbook_path)
      @source = Pathname.new cookbook_path
    end

    # the path to the source file in the cookbook tree
    attr_reader :source

    # The path for where the file should be installed. Todo, remove reference to ENV['HOME'] here.
    def target
      target = @source.to_s \
        .sub(%r"#{Regexp.escape CONFIG.root_path.to_s}/cookbooks/[^/]+/dotfiles", CONFIG.install_path.to_s) \
        .gsub(%r/(\W|^)dot_(\w+)/, '\1.\2')

      Pathname.new target
    end
  end
end
