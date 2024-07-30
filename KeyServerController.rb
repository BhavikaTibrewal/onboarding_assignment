require "sinatra"

get '/' do
  "Server running"
end

get '/generate' do
  puts "started"

  puts key.key_name
end
