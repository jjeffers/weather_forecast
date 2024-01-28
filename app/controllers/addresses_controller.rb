# frozen_string_literal: true

class AddressesController < ApplicationController

  def search
    results = []

    if params[:query].present?
      results = helpers.fetch_address(params[:query])
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('suggestions',
                              partial: 'addresses/suggestions',
                              locals: { results: })
        ]
      end
    end
  end
end
