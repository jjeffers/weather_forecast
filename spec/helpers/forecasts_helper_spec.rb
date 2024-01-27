require 'rails_helper'

class MockGeocoderResult
  def coordinates
    [1,2]
  end
end

RSpec.describe ForecastsHelper, type: :helper do
  describe "featch_address_coordinates" do
    it "fetches address_coordinates from geocoder" do
      allow(Geocoder).to receive(:search).and_return([MockGeocoderResult.new])
        
      coordinates = helper.fetch_address_coordinates("123 Main St")
      expect(coordinates.length).to eq(2)
    end

    it "handles an emrpty response from the geocoder" do
      allow(Geocoder).to receive(:search).and_return([])
        
      coordinates = helper.fetch_address_coordinates("123 Main St")
      expect(coordinates.length).to eq(0)
    end
  end

  describe "fetch_weather" do
    it "fetches weather data from the weather API" do
      stub_request(:get, /api.open-meteo.com/).
        to_return(
            status: 200, 
            body: { features: [] }.to_json, 
            headers: {})

      weather_data = helper.fetch_weather(1,2)
    end

    it "handles an error response from the weather API" do
      stub_request(:get, /api.open-meteo.com/).
        to_return(
        status: 406,
        body: {"reason":"Parameter 'latitude' and 'longitude' must have the same number of elements","error":true}.to_json,
        headers: {})

      weather_data = helper.fetch_weather(1,2)
    end
  end
end
