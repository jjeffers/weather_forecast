class ForecastsController < ApplicationController
  def show
    if params[:query].present?
      latitude, longitude = helpers.fetch_address_coordinates(params[:query])
      @forecast = helpers.fetch_weather(latitude, longitude)
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
