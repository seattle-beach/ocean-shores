require 'rake/testtask'

namespace :dev do
  desc 'Start development server'
  task :start do
    sh 'rerun --no-notify -- ruby lib/ocean_shores/app.rb'
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

task default: :test
