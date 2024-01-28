# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AddressesHelper, type: :helper do
  describe 'fetch_address' do
    it 'returns a array of address data' do
      stub_request(:any, /api.geoapify.com/)
        .to_return(status: 200,
                   body: { features: [{ properties: { formatted: '123 Main Street Oakdale IL 67705' } }] }.to_json,
                   headers: {})

      result = helper.fetch_address('123 Main St')
      expect(result.length).to eq(1)
    end

    it 'handles an empty search set from the API' do
      stub_request(:any, /api.geoapify.com/)
        .to_return(status: 200, body: { features: [] }.to_json, headers: {})

      result = helper.fetch_address('')
      expect(result.length).to eq(0)
    end

    it 'handles an failure status from API' do
      stub_request(:any, /api.geoapify.com/)
        .to_return(status: 401,
                   body: { "statusCode": 401, "error": 'Unauthorized', "message": 'Invalid apiKey' }.to_json,
                   headers: {})
      result = helper.fetch_address('123 Main St')

      expect(result.length).to eq(0)
    end
  end
end
