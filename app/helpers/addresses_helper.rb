# frozen_string_literal: true

module AddressesHelper
  GEOAPIFY_API_KEY = 'b83e3e4a0f774e36a872fae75f31ab89'

  def fetch_address(address_text)
    results = []
    request_url = "https://api.geoapify.com/v1/geocode/search?text=#{address_text}&apiKey=#{GEOAPIFY_API_KEY}"
    Rails.logger.debug "Geoapify Request: #{request_url}"

    conn = Faraday.new do |faraday|
      faraday.response :raise_error, include_request: true
    end

    begin
      response = conn.get(request_url)
      json = JSON.parse(response.body)

      Rails.logger.debug "Geoapify Response: #{JSON.pretty_generate(json)}"

      results = format_address_response(json['features']) if json['features'].present?
    rescue Faraday::Error => e
      Rails.logger.error "Address look up failed: #{e.response[:status]} - #{e.response[:body]}"
    end

    Rails.logger.debug "Query results: #{results}"
    results
  end

  def format_address_response(data)
    data.map do |feature|
      {
        address: feature['properties']['formatted'],
        latitude: feature['properties']['lat'],
        longitude: feature['properties']['lon'],
        postcode: feature['properties']['postcode'],
        country_code: feature['properties']['country_code']
      }
    end
  end
end
