# frozen_string_literal: true

module ForecastsHelper
  def fetch_weather(_country_code, _postcode, latitude, longitude, _options = {})
    result = []
    request_url = "https://api.open-meteo.com/v1/forecast?latitude=#{latitude.round(2)}" \
                  "&longitude=#{longitude.round(2)}" \
                  '&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min'

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

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/CyclomaticComplexity
  def weather_description_from_code(weather_code)
    # See documentation at https://open-meteo.com/en/docs
    case weather_code.to_i
    when 0
      'Clear sky'
    when 1..3
      'Mainly clear, partly cloudy, and overcast'
    when 45..48
      'Fog and depositing rime fog'
    when 51..55
      'Drizzle: Light, moderate, and dense intensity'
    when 56..57
      'Freezing Drizzle: Light and dense intensity'
    when 61..65
      'Rain: Slight, moderate and heavy intensity'
    when 66..67
      'Freezing Rain: Light and heavy intensity'
    when 71..75
      'Snow fall: Slight, moderate, and heavy intensity'
    when 77
      'Snow grains'
    when 80..82
      'Rain showers: Slight, moderate, and violent'
    when 85..86
      'Snow showers slight and heavy'
    when 95
      'Thunderstorm: Slight or moderate'
    when 96..99
      'Thunderstorm with slight and heavy hail'
    else
      ''
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
end
