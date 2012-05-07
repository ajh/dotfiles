require 'pathname'

Dir.glob(Pathname.new(__FILE__).dirname.join('dotfiles/**/*.rb')) do |rb|
  require rb
end

module Dotfiles
  @debug = true
  @force = false

  class << self
    attr_accessor :debug, :force
  end
end
