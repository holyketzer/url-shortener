ENV["RACK_ENV"] = "test"

require "./app"
require "rspec"
require "rack/test"

describe App do
  include Rack::Test::Methods

  def app
    App
  end

  describe "success way" do
    let(:long_url) { "https://medium.com/@fbzga/rust-to-the-rescue-of-ruby-2067f5e1dc25" }

    it "should short URL" do
      post "/", { longUrl: long_url }.to_json

      expect(last_response.status).to eq 200
      expect(last_response.header["Content-Type"]).to eq "application/json"
      body = JSON.parse(last_response.body)
      expect(body["url"]).to match /.+#{Rack::Test::DEFAULT_HOST}\/[a-zA-z0-9]{8}/

      get body["url"]

      expect(last_response.status).to eq 301
      expect(last_response["Location"]).to eq long_url
    end
  end

  describe "uid not present" do
    it "should return error" do
      get "/not_presented_uid"
      expect(last_response.status).to eq 404
    end
  end

  describe "validation" do
    it "should return error" do
      post "/", { longUrl: '' }.to_json
      expect(last_response.status).to eq 400
    end
  end

  describe "URL sanitization" do
    let(:malicious_url) { "javascript:alert('XSS')" }

    it "should return error" do
      post "/", { longUrl: malicious_url }.to_json
      expect(last_response.status).to eq 400
    end
  end
end