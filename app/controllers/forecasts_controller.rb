class ForecastsController < ApplicationController
  def show
    if params[:query].present?
      @country_code = params[:country_code]
      @postcode = params[:postcode]
      @forecast = Rails.cache.fetch("#{@country_code}#{@postcode}", expires_in: 30.minutes) do
        helpers.fetch_weather(@country_code, @postcode, params[:latitude].to_f, params[:longitude].to_f)
      end
      
    end

    respond_to do |format|
      format.html
      format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("forecast",
            partial: "forecasts/forecast",
            locals: { forecast: @forecast })
          ]
      end
    end
  end
end
