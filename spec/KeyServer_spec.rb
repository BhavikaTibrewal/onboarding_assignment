ENV['APP_ENV'] = 'test'

require_relative '../KeyServerRoutes'
require_relative '../KeyServerModel'
require 'rspec'
require 'rack/test'

RSpec.describe 'The Key KeyController App URL: /' do
  include Rack::Test::Methods

  def app
    KeyServerRoutes.new
  end

  let(:key_server) { instance_double(KeyServerModel) }
  before do
    allow(KeyServerModel).to receive(:new).and_return(key_server)
  end

  describe "GET /" do
    it "returns server running message" do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Server running')
    end
  end

  describe "GET /generate" do
    it "Generate a key" do
      get '/generate'
      expect(last_response).to be_ok
    end
  end

  describe "PATCH /key/:key" do
    it "Generate and unblock key" do
      get '/generate'
      get '/key'
      patch '/key/' + last_response.body
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Key unblocked successfully.')
    end
    it "Unblock an invalid key" do
      patch '/key/' + SecureRandom.hex(8)
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("Key not in use.")
    end
  end

  describe "DELETE /key/:key" do
    it "Delete an available key" do
      get '/generate'
      delete '/key/' + last_response.body
      expect(last_response).to be_ok
      expect(last_response.body).to eq("Key deleted successfully")
    end
    it "Delete a key in use" do
      get '/generate'
      get '/key'
      delete '/key/' + last_response.body
      expect(last_response).to be_ok
      expect(last_response.body).to eq("Key deleted successfully")
    end
    it "Delete a key in use" do
      get '/generate'
      get '/key'
      key = last_response.body
      delete '/key/' + key
      delete '/key/' + key
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("Key Already Deleted")
    end
    it "Unblock an invalid key" do
      delete '/key/' + SecureRandom.hex(8)
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("Invalid key")
    end
  end

  describe "GET /key/keep-alive" do
    it "Called with a key that is not in use" do
      get '/generate'
      get "/key/keep-alive?key=" + last_response.body
      expect(last_response.status).to eq(400)
      expect(last_response.body).to eq("Invalid key")
    end
    it "refresh a key" do
      get '/generate'
      get '/key'
      get "/key/keep-alive?key=" + last_response.body
      expect(last_response).to be_ok
      expect(last_response.body).to eq("Key refreshed successfully")
    end
  end

end