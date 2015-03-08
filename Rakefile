#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'lib/frontend_rescue'
  t.test_files = FileList['test/lib/frontend_rescue/*_test.rb']
  t.verbose = true
end

task default: :test
