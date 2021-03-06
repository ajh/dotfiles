require 'rake/testtask'
require 'pathname'
require 'shellwords'

require Pathname.new(__FILE__).dirname.join('lib', 'dotfiles')

Dotfiles.force = true if %w(true 1 yes).include?(ENV['force'])
groups = Dir.glob("configs/*").collect { |f| Dotfiles::Group.new(f) if File.directory?(f) }

# Add a module named the same as a group name and define an .install method to
# have the method called when the group is installed.
module Hooks
  module Vim
    def self.install
      File.directory?(Pathname.new(ENV['HOME'])) and return
      puts "Don't forget to install or update janus for vim: https://github.com/carlhuda/janus"
    end
  end

  module Git
    CONFIG = {
      'alias.a'           => 'add',
      'alias.ci'          => 'commit',
      'alias.co'          => 'checkout',
      'alias.d'           => 'diff',
      'alias.dc'          => 'diff --cached',
      'alias.ld'          => 'log --left-right --graph --cherry-pick --oneline', # list which commits differ between branches like: git ld master...feature_branch
      'alias.lg'          => 'log --graph --pretty=oneline --abbrev-commit',
      'alias.lp'          => 'log --patch --decorate',
      'alias.st'          => 'status',
      'color.ui'          => 'auto',
      'core.excludesfile' => '~/.gitexcludes',
      'push.default'      => 'simple',
    }

    def self.install
      CONFIG.each do |name, value|
        add_config name, value or raise "Failed to add git config #{name} = #{value}"
      end
    end

    private

      def self.add_config(name, value, type=nil)
        cmd = "git config --global #{name.shellescape} #{value.shellescape}"
        puts cmd
        system cmd
      end
  end

  module Bash
    def self.install
      a = Dotfiles::UnmanagedFile::Additions.new Pathname.new(ENV['HOME']).join('.bashrc'), 'bash', '#'
      a.replace <<-SOURCE
for rc in $HOME/.bash.d/*.sh; do source $rc; done
      SOURCE
    end
  end

  # Calls a install hook if one exists for group_name
  def self.install(group_name)
    Hooks.const_defined?(group_name.to_s.capitalize) or return
    mod = Hooks.const_get(group_name.to_s.capitalize)
    mod.respond_to?(:install) or return
    mod.send :install
  end
end

namespace :install do
  groups.each do |group|
    desc "install configs for #{group.name}. Use force=true option to replace existing files."
    task group.name do 
      group.install ENV['HOME']
      Hooks.install group.name
    end
  end
end

desc "install all dotfiles"
task :install => groups.collect {|g| "install:#{g.name}"}
task :default => :install

desc 'run tests against this rake script'
Rake::TestTask.new('test') do |t|
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
