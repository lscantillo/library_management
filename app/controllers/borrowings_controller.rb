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
        redirect_to books_path, notice: "Libro pedido exitosamente."
      else
        redirect_to books_path, alert: "No se pudo procesar el préstamo."
      end
    else
      alert_message = if existing_borrowing
                        "Ya tienes un préstamo activo para este libro."
      else
                        "El libro no está disponible para préstamo."
      end
      redirect_to books_path, alert: alert_message
    end
  end

  def return_book
    if @borrowing.returned_at.nil?
      @borrowing.update(returned_at: Time.current)
      @borrowing.book.update(available_copies: @borrowing.book.available_copies + 1)
      redirect_to librarian_dashboard_path, notice: "El libro ha sido marcado como devuelto."
    else
      redirect_to librarian_dashboard_path, alert: "El libro ya ha sido devuelto anteriormente."
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
    redirect_to root_path, alert: "No tienes permisos para realizar esta acción." unless current_user&.librarian?
  end
end
