class Api::V1::DataController < Api::V1::ApplicationController
  def genres
    @genres = params[:query].present? ? Genre.search_genres(params[:query]) : Genre.all
    @pagy, @genres = pagy_array(@genres)
    render json: { genres: @genres, pagy: pagy_metadata(@pagy) }, status: :ok
  end

  def authors
    @authors = params[:query].present? ? Author.search_authors(params[:query]) : Author.all
    @pagy, @authors = pagy_array(@authors)
    render json: { authors: @authors, pagy: pagy_metadata(@pagy) }, status: :ok
  end
end
