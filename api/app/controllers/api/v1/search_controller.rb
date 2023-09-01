class Api::V1::SearchController < ApplicationController
  def search
    search_terms = params[:search]
    service = GameSearchService.new(search_terms)
    result = service.call

    if result[:error]
      render json: result[:error], status: :internal_server_error
    else
      render json: result[:games]
    end
  end
end
