class Api::V1::BorrowingsController < Api::V1::ApplicationController
  before_action :set_book, only: [ :create ]
  before_action :set_borrowing, only: [ :return_book ]
  before_action :ensure_librarian, only: [ :return_book ]

  def index
    if params[:active].present? && params[:active] == "true"
      @borrowings = current_user.borrowings.includes(:book).where(returned_at: nil)
    else
      @borrowings = current_user.borrowings.includes(:book)
    end
    @pagy, @borrowings = pagy_array(@borrowings)
    render json: { borrowings: @borrowings, pagy: pagy_metadata(@pagy) }, status: :ok
  end

  def create
    existing_borrowing = Borrowing.find_by(user: current_user, book: @book, returned_at: nil)

    if @book.available_copies > 0 && !current_user.librarian? && existing_borrowing.nil?
      @borrowing = Borrowing.new(user: current_user, book: @book, borrowed_at: Time.current, due_date: 2.weeks.from_now)

      if @borrowing.save
        @book.update(available_copies: @book.available_copies - 1)
        render json: { message: "Book successfully borrowed.", book: { title: @book.title, due_date: @borrowing.due_date } }, status: :ok
      else
        render json: { message: "Book could not be borrowed." }, status: :unprocessable_entity
      end
    else
      alert_message = if existing_borrowing
                        "Already have an active borrowing for this book."
      else
                        "Book is not available for borrowing."
      end
      render json: { message: alert_message }, status: :unprocessable_entity
    end
  end

  def return_book
    if @borrowing.returned_at.nil?
      @borrowing.update(returned_at: Time.current)
      @borrowing.book.update(available_copies: @borrowing.book.available_copies + 1)
      render json: { message: "Book marked as returned." }, status: :ok
    else
      render json: { message: "Book has already been returned." }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  end

  def ensure_librarian
    render json: { message: "You don't have permission to do this." }, status: :unauthorized unless current_user&.librarian?
  end
end
