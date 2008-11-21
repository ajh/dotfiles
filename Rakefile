require 'rake/testtask'
require 'rake/lib/section'
require 'find'

dotfiles = []
Find.find('home') { |f| dotfiles << File.expand_path(f) if File.file?(f) }
sections = Section.create_from_files(dotfiles)

namespace :install do
  sections.each do |section|
    desc "install configs for #{section.name}"
    task section.name do 
      section.install
    end
  end
end

desc "install all dotfiles"
task :install => sections.collect {|s| "install:#{s.name}"}
task :default => :install

desc 'run tests against this rake script'
Rake::TestTask.new('test') do |t|
  t.pattern = 'rake/test/test_*.rb'
  t.verbose = true
end
