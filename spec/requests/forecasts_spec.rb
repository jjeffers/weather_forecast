# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  let(:open_meteo_response) do
    {
      "product": 'civillight',
      "init": '2021-03-16T00:00:00Z',
      "dataseries": [
        {
          "timepoint": 3,
          "cloudcover": 0,
          "lifted_index": 0,
          "prec_type": 'none',
          "prec_amount": 0,
          "temp2m": 9,
          "rh2m": 71,
          "wind10m": {
            "direction": 0,
            "speed": 0
          },
          "weather": 'clearsky'
        }
      ]
    }
  end

  describe 'GET /show' do
    it 'returns http success without query' do
      get forecast_path
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with an empty query' do
      get forecast_path, params: { query: '' }
      expect(response).to have_http_status(:success)
    end

    it 'returns http success with a query ' do
      allow_any_instance_of(ForecastsHelper).to receive(:fetch_weather).and_return([open_meteo_response])

      get forecast_path, params: { query: '123 Oak Street' }
      expect(response).to have_http_status(:success)
    end
  end
end
