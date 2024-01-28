require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'GET /show' do
    it 'returns http success without query' do
      get forecast_path
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with an empty query' do
      get forecast_path, params: { query: '' }
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with a query but no geo-located data' do
      get forecast_path, params: { query: '123 Oak Street' }
      expect(response).to have_http_status(:success)
    end
  end
end
