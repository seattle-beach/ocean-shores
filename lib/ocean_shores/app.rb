require 'sinatra/base'

module OceanShores
  class App < Sinatra::Base
    get '/' do
      'Hello World!'
    end

    run! if app_file == $0
  end
end
