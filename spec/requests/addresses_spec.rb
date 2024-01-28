# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Addresses', type: :request do
  describe 'GET /search' do
    it 'returns http success with good address ' do
      allow_any_instance_of(AddressesHelper).to receive(:fetch_address).and_return(
        [{ address: '124 Main St', longitude: 23, latitude: 20, postcode: 77631, country_code: 'us'}])

      get search_addresses_path, params: { query: '123 Main St' }, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it 'handles a missing query' do
      get search_addresses_path, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it 'handles an empty search set from the API' do
      allow_any_instance_of(AddressesHelper).to receive(:fetch_address).and_return(
        [{ address: '124 Main St', longitude: 23, latitude: 20, postcode: 77631, country_code: 'us'}])

      get search_addresses_path, params: { query: '123 Main St' }, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end

    it 'handles an empty result from the search' do
      allow_any_instance_of(AddressesHelper).to receive(:fetch_address).and_return([])
      get search_addresses_path, params: { query: '123 Main St' }, as: :turbo_stream
      expect(response).to have_http_status(:success)
    end
  end
end
