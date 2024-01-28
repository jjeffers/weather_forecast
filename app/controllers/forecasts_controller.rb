# frozen_string_literal: true

class ForecastsController < ApplicationController
  def show
    if params[:address].present? &&
       params[:latitude].present? &&
       params[:longitude].present? &&
       params[:country_code].present? &&
       params[:postcode].present?

      @address = params[:address]

      @cached = Rails.cache.exist?("#{params[:country_code]}#{params[:postcode]}")
      Rails.logger.debug "Cache key: #{params[:country_code]}#{params[:postcode]} - #{@cached}"
      @forecast = Rails.cache.fetch("#{params[:country_code]}#{params[:postcode]}", expires_in: 30.minutes) do
        helpers.fetch_weather(params[:country_code],
                              params[:postcode], params[:latitude].to_f, params[:longitude].to_f)
      end
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('forecast',
                              partial: 'forecasts/forecast',
                              locals: { forecast: @forecast })
        ]
      end
    end
  end
end
