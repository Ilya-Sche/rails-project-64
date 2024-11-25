# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
require 'slim_lint/cli'
require_relative "config/application"
require 'rubocop/rake_task'

Rails.application.load_tasks

task :lint do
    system('slim-lint app/views')
  end

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rails'
end