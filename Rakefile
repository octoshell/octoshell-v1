#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

MSU::Application.load_tasks

if Rails.env.test?
  require 'ci/reporter/rake/rspec'
  require 'ci/reporter/rake/cucumber' 
end
