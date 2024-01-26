require 'rails_helper'

RSpec.describe "Addresses", type: :request do
  describe "GET /search" do
    it "returns http success" do
      get "/address/search"
      expect(response).to have_http_status(:success)
    end
  end

end
