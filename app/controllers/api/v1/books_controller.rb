class Api::V1::BooksController < Api::V1::ApplicationController
  before_action :authorize_user, only: [ :create, :update, :destroy ]
  before_action :search_books, only: %i[index]
  before_action :set_book, only: %i[update destroy]

  def index
    render json: { books: @books, pagy: pagy_metadata(@pagy) }, status: :ok
  end

  # POST /api/v1/books
  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/books/:id
  def update
    if @book.update(book_params)
      render json: @book, status: :ok
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/books/:id
  def destroy
    @book.destroy!
    render json: { message: "Book was successfully destroyed." }, status: :see_other
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Book not found" }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :author_id, :genre_id, :isbn, :total_copies)
  end

  def search_books
    @books = params[:query].present? ? Book.search_books(params[:query]) : Book.all
    @pagy, @books = pagy_array(@books)
  end
end
