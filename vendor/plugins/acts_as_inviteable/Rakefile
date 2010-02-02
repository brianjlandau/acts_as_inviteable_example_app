require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the acts_as_inviteable plugin.'
task :test do
  errors = %w(test:acts_as test:generator).collect do |task|
    begin
      Rake::Task[task].invoke
      nil
    rescue => e
      task
    end
  end.compact
  abort "Errors running #{errors.to_sentence}!" if errors.any?
end

namespace :test do
  desc 'Run the "acts_as" tests'
  Rake::TestTask.new(:acts_as) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/acts_as_*_test.rb'
    t.verbose = true
  end
  
  desc 'Run the "generator" tests'
  Rake::TestTask.new(:generator) do |t|
    t.libs << 'lib'
    t.libs << 'test'
    t.pattern = 'test/*generator_test.rb'
    t.verbose = true
  end
end

desc 'Generate documentation for the acts_as_inviteable plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActsAsInviteable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
