class BorrowingsController < ApplicationController
  before_action :set_book, only: [:create, :return]

  def create
    # Verificar si el libro tiene copias disponibles y si el usuario no es librarian
    if @book.available_copies > 0 && !current_user.librarian?
      @borrowing = Borrowing.new(user: current_user, book: @book, borrowed_at: Time.current, due_date: 2.weeks.from_now)

      if @borrowing.save
        @book.update(available_copies: @book.available_copies - 1)
        redirect_to books_path, notice: 'Libro pedido exitosamente.'
      else
        redirect_to books_path, alert: 'No se pudo procesar el préstamo.'
      end
    else
      redirect_to books_path, alert: 'El libro no está disponible para préstamo.'
    end
  end

  def return
    @borrowing = Borrowing.find_by(user: current_user, book: @book, returned_at: nil)

    if @borrowing
      @borrowing.update(returned_at: Time.current)
      @book.update(available_copies: @book.available_copies + 1)
      redirect_to user_dashboard_path(current_user), notice: 'Libro devuelto exitosamente.'
    else
      redirect_to user_dashboard_path(current_user), alert: 'No se encontró el préstamo activo.'
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end
end
