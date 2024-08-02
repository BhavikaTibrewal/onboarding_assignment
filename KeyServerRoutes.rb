require "sinatra"
require './KeyServerModel'

set :port, 8080
set :static, true
set :public_folder, "static"

class KeyServerRoutes < Sinatra::Application
  keyServer = KeyServerModel.new

  get '/' do
    status 200
    "Server running"
  end

  get '/generate' do
    key = keyServer.generate_key

    status 200
    body key
  end

  # Endpoint for fetching a key from available keys
  get '/key' do
    key = keyServer.get_key
    if key == nil
      status 404
      body "No spare Key available. Generate keys using /generate-keys endpoint"
    else
      status 200
      body key
    end
  end

  # unblock key
  patch '/key/:key' do |key|
    unblocked, message = keyServer.unblock_key(key)
    if unblocked
      status 200
      body "Key unblocked successfully."
    else
      status 400
      message
    end
  end

  delete '/key/:key' do |key|
    deleted, message = keyServer.delete_key(key)
    if deleted
      status 200
      body "Key deleted successfully"
    else
      status 400
      message
    end
  end

  # Endpoint to keep the key alive for next 5 min
  get '/key/keep-alive' do
    key = params['key']
    refreshed, message = keyServer.refresh_key(key)
    if refreshed
      status 200
      body "Key refreshed successfully"
    else
      status 400
      message
    end
  end

  get '/*' do
    status 404
    "You have stumbled on an invalid endpoint"
  end

  Thread.new do
    loop do
      sleep 1
      keyServer.cron
    end
  end
end