require 'sequel'

Sequel::Model.plugin :timestamps, update_on_create: true

module OceanShores
  DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
end
