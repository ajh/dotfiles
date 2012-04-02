require 'pathname'

module DotFiles
  class Config
    # path to root of dotfiles project
    attr_accessor :root_path

    # path where dotfiles are to be installed. Normally ENV['HOME'].
    attr_accessor :install_path
  end

  CONFIG = Config.new.tap {|c|
    c.root_path = Pathname.new(__FILE__).dirname.join('../..')
    c.install_path = Pathname.new ENV['HOME']
  }
end
