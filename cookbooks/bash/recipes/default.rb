require 'pathname'
require 'find'

class Config
  # path to root of dotfiles project
  attr_accessor :root_path

  # path where dotfiles are to be installed. Normally ENV['HOME'].
  attr_accessor :install_path
end

CONFIG = Config.new.tap {|c|
  c.root_path = Pathname.new(__FILE__).dirname.join('../../..')
  c.install_path = Pathname.new ENV['HOME']
}

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

DotFile.find('bash').each do |dotfile|
  directory dotfile.target.dirname.to_s
  link(dotfile.target.to_s) { to dotfile.source.to_s }
end
