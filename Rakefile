require 'rake/testtask'
require 'find'
require 'rake/lib/group'

groups = Dir.glob("configs/*").collect { |f| DotFiles::Group.new(f) if File.directory?(f) }

namespace :install do
  groups.each do |group|
    desc "install configs for #{group.name}"
    task group.name do 
      group.install ENV['HOME']
    end
  end
end

desc "install all dotfiles"
task :install => groups.collect {|g| "install:#{g.name}"}
task :default => :install

desc 'run tests against this rake script'
Rake::TestTask.new('test') do |t|
  t.pattern = 'rake/test/test_*.rb'
  t.verbose = true
end
