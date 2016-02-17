require 'sequel'

module OceanShores
  DB = Sequel.connect(ENV.fetch('DATABASE_URL'))
end
