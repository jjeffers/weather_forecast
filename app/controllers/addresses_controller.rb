

class AddressesController < ApplicationController
  include HTTParty
  GEOAPIFY_API_KEY = "b83e3e4a0f774e36a872fae75f31ab89"

  def search
    results = ['']

    if params.dig(:query).present?
      address_text = params[:query]
      
      request_url = "https://api.geoapify.com/v1/geocode/search?text=#{address_text}&apiKey=#{GEOAPIFY_API_KEY}"

      Rails.logger.debug "Geoapify Request: #{request_url}"

      response = HTTParty.get(request_url)

      Rails.logger.debug "Geoapify Response: #{response.code}"
      json = JSON.parse(response.body)

      Rails.logger.debug "Geoapify Response: #{JSON.pretty_generate(json)}"

      if json.dig("features").present?
        results = json["features"].map do |feature|
          { 
            address: feature["properties"]["formatted"],
            latitude: feature["properties"]["lat"],
            longitude: feature["properties"]["lon"]
          }
        end
      end

      Rails.logger.debug results
    end

    respond_to do |format|
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("suggestions",
            partial: "addresses/suggestions",
            locals: { results: results })
          ]
      end
    end
  end
end
