require 'pathname'
require 'find'
require Pathname.new(__FILE__).dirname.join('../../../lib/dotfiles')

DotFiles::DotFile.find('vim').each do |dotfile|
  directory dotfile.target.dirname.to_s
  link(dotfile.target.to_s) { to dotfile.source.to_s }
end
