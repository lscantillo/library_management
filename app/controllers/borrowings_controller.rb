class BorrowingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [ :create ]
  before_action :set_borrowing, only: [ :return_book ]
  before_action :ensure_librarian, only: [ :return_book ]

  def create
    existing_borrowing = Borrowing.find_by(user: current_user, book: @book, returned_at: nil)

    if @book.available_copies > 0 && !current_user.librarian? && existing_borrowing.nil?
      @borrowing = Borrowing.new(user: current_user, book: @book, borrowed_at: Time.current, due_date: 2.weeks.from_now)

      if @borrowing.save
        @book.update(available_copies: @book.available_copies - 1)
        redirect_to books_path, notice: "Book successfully borrowed."
      else
        redirect_to books_path, alert: "Book could not be borrowed."
      end
    else
      alert_message = if existing_borrowing
                        "Already have an active borrowing for this book."
      else
                        "Book is not available for borrowing."
      end
      redirect_to books_path, alert: alert_message
    end
  end

  def return_book
    if @borrowing.returned_at.nil?
      @borrowing.update(returned_at: Time.current)
      @borrowing.book.update(available_copies: @borrowing.book.available_copies + 1)
      redirect_to book_management_path, notice: "Book marked as returned."
    else
      redirect_to book_management_path, alert: "Book has already been returned."
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
    redirect_to root_path, alert: "You don't have permission to do this." unless current_user&.librarian?
  end
end
