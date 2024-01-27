require 'rails_helper'

RSpec.describe "Addresses", type: :request do
  describe "GET /search" do
    it "returns http success with good address " do
      stub_request(:any, /api.geoapify.com/).
         to_return(
          status: 200, 
          body: { features: [{ properties: { formatted: "123 Main Street Oakdale IL 67705" } }] }.to_json, 
          headers: {})

      get search_addresses_path, params: { query: "123 Main St" }, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it "handles a missing query" do
      get search_addresses_path, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it "handles an empty search set from the API" do
      stub_request(:any, /api.geoapify.com/).
         to_return(
          status: 200, 
          body: { features: [] }.to_json, 
          headers: {})


      get search_addresses_path, params: { query: "123 Main St" },  as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it "handles an faiure status from API" do
      stub_request(:any, /api.geoapify.com/).
         to_return(
          status: 401,
          body: {"statusCode":401,"error":"Unauthorized","message":"Invalid apiKey"}.to_json,
          headers: {})


      get search_addresses_path, params: { query: "123 Main St" },  as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end

end
