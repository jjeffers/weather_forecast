# frozen_string_literal: true

require 'rails_helper'

class MockGeocoderResult
  def coordinates
    [1, 2]
  end
end

RSpec.describe ForecastsHelper, type: :helper do
  describe 'fetch_weather' do
    it 'fetches weather data from the weather API' do
      stub_request(:get, /api.open-meteo.com/)
        .to_return(
          status: 200,
          body: { features: [] }.to_json,
          headers: {}
        )

      helper.fetch_weather('jp', '0877', 1, 2)
    end

    it 'handles an error response from the weather API' do
      stub_request(:get, /api.open-meteo.com/)
        .to_return(
          status: 406,
          body: { "reason": "Parameter 'latitude' and 'longitude' must have the same number of elements",
                  "error": true }.to_json,
          headers: {}
        )

      helper.fetch_weather('jp', '0877', 1, 2)
    end
  end

  describe 'weather_description_from_weather_code' do
    it "returns a 'Clear Sky' for weather code '0'" do
      expect(helper.weather_description_from_code('0')).to eq('Clear sky')
    end

    it "returns a '' for weather code -01" do
      expect(helper.weather_description_from_code(-1)).to eq('')
    end

    it "returns a '' for weather code 101" do
      expect(helper.weather_description_from_code(101)).to eq('')
    end
  end
end
