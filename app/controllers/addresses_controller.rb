# frozen_string_literal: true

class AddressesController < ApplicationController
  def search
    results = []
    results = helpers.fetch_address(params[:query]) if params[:query].present?

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
