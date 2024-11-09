class BooksController < ApplicationController
  before_action :authorize_user, only: [ :edit, :destroy, :update, :book_management ]
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :set_dashboard_data, only: %i[ index book_management ]

  # GET /books or /books.json
  def index
    if params[:query].present?
      @books = Book.search_books(params[:query])
    else
      @books = Book.all
    end
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_path, status: :see_other, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def book_management
    if params[:query].present?
      @books = Book.search_books(params[:query])
    else
      @books = Book.all
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :author, :genre, :isbn, :total_copies, :available_copies)
    end

    def set_dashboard_data
      @borrowings = current_user.borrowings.includes(:book) if current_user.member?
      @borrowings = Borrowing.includes(:user, :book).where(returned_at: nil) if current_user.librarian?
      @total_books = Book.count
      @total_borrowed_books = Borrowing.where(returned_at: nil).count
      @books_due_today = Borrowing.where(due_date: Date.today, returned_at: nil).count
      @members_with_overdue_books = Borrowing.includes(:user, :book).where('due_date < ?', Date.today).where(returned_at: nil)
    end
end
