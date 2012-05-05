require 'pathname'
require Pathname.new(__FILE__).dirname.join('dotfiles', 'config')
require Pathname.new(__FILE__).dirname.join('dotfiles', 'dotfile')
require Pathname.new(__FILE__).dirname.join('dotfiles', 'unmanaged_file_additions')

module Dotfiles
end
