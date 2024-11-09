class BooksController < ApplicationController
  before_action :authorize_user, only: %i[edit destroy update book_management]
  before_action :set_book, only: %i[show edit update destroy]
  before_action :set_dashboard_data, only: %i[index book_management]
  before_action :search_books, only: %i[index book_management]

  # GET /books or /books.json
  def index; end

  # GET /books/1 or /books/1.json
  def show; end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit; end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)
    respond_with_status(@book.save, :new)
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_with_status(@book.update(book_params), :edit)
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!
    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def book_management; end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :isbn, :total_copies, :available_copies, :author_id, :genre_id)
  end

  def set_dashboard_data
    if current_user.member?
      @borrowings = current_user.borrowings.includes(:book)
    elsif current_user.librarian?
      @borrowings = Borrowing.includes(:user, :book).where(returned_at: nil)
    end
    @total_books = Book.count
    @total_borrowed_books = Borrowing.where(returned_at: nil).count
    @books_due_today = Borrowing.where(due_date: Date.today, returned_at: nil).count
    @members_with_overdue_books = Borrowing.includes(:user, :book).where('due_date < ?', Date.today).where(returned_at: nil)
  end

  def search_books
    @books = params[:query].present? ? Book.search_books(params[:query]) : Book.all
    @pagy, @books = pagy_array(@books)
  end

  def respond_with_status(success, render_action)
    respond_to do |format|
      if success
        format.html { redirect_to book_management_path, notice: "Book was successfully #{action_name == 'create' ? 'created' : 'updated'}." }
        format.json { render :show, status: success ? :ok : :unprocessable_entity, location: @book }
      else
        format.html { render render_action, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
end
