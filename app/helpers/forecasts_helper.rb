module ForecastsHelper

    def fetch_address_coordinates(address_text)
        Rails.logger.debug "Looking up coordinates for '#{address_text}'"
        results = Geocoder.search(address_text)

        Rails.logger.debug "Geocoder Results: #{results.inspect}"

        results.first.coordinates
    end

    def fetch_weather(latitude, longitude, options={})
        request_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude.round(2)}&longitude=#{longitude.round(2)}" +
            "&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min"

        response = Faraday.get(request_url)

        Rails.logger.debug "OpenMeteo Response: #{response.code}"
        json = JSON.parse(response.body)
      
        Rails.logger.debug "OpenMeteo Response: #{JSON.pretty_generate(json)}"

        json
    end    
end
