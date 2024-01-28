# frozen_string_literal: true

class ForecastsController < ApplicationController
  def show
    if params[:address].present? &&
       params[:latitude].present? &&
       params[:longitude].present? &&
       params[:country_code].present? &&
       params[:postcode].present?

      @country_code = params[:country_code]
      @postcode = params[:postcode]
      @address = params[:address]

      @cached = Rails.cache.exist?("#{@country_code}#{@postcode}")
      Rails.logger.debug "Cache key: #{@country_code}#{@postcode} - #{@cached}"
      @forecast = Rails.cache.fetch("#{@country_code}#{@postcode}", expires_in: 30.minutes) do
        helpers.fetch_weather(@country_code, @postcode, params[:latitude].to_f, params[:longitude].to_f)
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
