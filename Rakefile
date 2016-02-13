require 'rake/testtask'

$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

namespace :dev do
  desc 'Start development server'
  task :start do
    sh 'rerun --no-notify -- ruby lib/ocean_shores/app.rb'
  end

  desc 'Start an interactive console'
  task :console do
    require 'ocean_shores/db'
    require 'ocean_shores/models'
    include OceanShores

    require 'pry'
    binding.pry
  end
end

namespace :db do
  desc 'Run migrations'
  task :migrate, [:version] do |t, args|
    require 'ocean_shores/db'

    Sequel.extension :migration

    if args[:version]
      puts "Migrating to version #{args[:version]}"
      Sequel::Migrator.run(OceanShores::DB, 'db/migrations', target: args[:version].to_i)
    else
      puts 'Migrating to latest'
      Sequel::Migrator.run(OceanShores::DB, 'db/migrations')
    end

    OceanShores::DB.extension :schema_dumper
    File.write('db/schema.rb', OceanShores::DB.dump_schema_migration(same_db: true).gsub(/^\s+$/, ''))
  end
end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

task default: :test
