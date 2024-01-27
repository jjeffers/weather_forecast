module ForecastsHelper

    def fetch_address_coordinates(address_text)
        Rails.logger.debug "Looking up coordinates for '#{address_text}'"
        results = Geocoder.search(address_text)

        Rails.logger.debug "Geocoder Results: #{results.inspect}"

        if results.empty?
            []
        else
            results.first.coordinates
        end
    end

    def fetch_weather(latitude, longitude, options={})
        result = []
        request_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude.round(2)}&longitude=#{longitude.round(2)}" +
            "&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min"

        conn = Faraday.new do |faraday|
            faraday.response :raise_error, include_request: true
        end
        
        begin
            response = conn.get(request_url)
            result = JSON.parse(response.body)
        
            Rails.logger.debug "OpenMeteo Response: #{JSON.pretty_generate(result)}"
        rescue Faraday::Error => e
            Rails.logger.error "Weather look up failed: #{e.response[:status]} - #{e.response[:body]}"
        end

        result
    end    
end
