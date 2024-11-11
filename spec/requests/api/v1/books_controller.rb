require 'rails_helper'

RSpec.describe 'Api::V1::BooksController', type: :request do
  let!(:user) { create(:user, role: :librarian) }
  let!(:auth_token) { authenticate_user }
  let!(:headers) { { 'Authorization' => "Bearer #{auth_token}" } }

  let!(:genre) { create(:genre) }
  let!(:author) { create(:author) }
  let!(:books) { create_list(:book, 5, genre: genre, author: author) }

  describe 'GET #index' do
    context 'without a query' do
      it 'returns all books with pagination metadata' do
        get '/api/v1/books', headers: headers
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['books'].size).to eq(5)
        expect(parsed_response).to have_key('pagy')
      end
    end

    context 'with a query' do
      before { allow(Book).to receive(:search_books).and_return(books.take(3)) }

      it 'returns matching books with pagination metadata' do
        get '/api/v1/books', params: { query: 'test' }, headers: headers
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['books'].size).to eq(3)
        expect(parsed_response).to have_key('pagy')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:valid_attributes) do
        {
          book: {
            title: 'New Book',
            author_id: author.id,
            genre_id: genre.id,
            isbn: '123-456-789',
            total_copies: 5
          }
        }
      end

      it 'creates a new book' do
        expect {
          post '/api/v1/books', params: valid_attributes, headers: headers
        }.to change(Book, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        { book: { title: '', author_id: nil, genre_id: nil, isbn: '', total_copies: -1 } }
      end

      it 'does not create a new book and returns errors' do
        expect {
          post '/api/v1/books', params: invalid_attributes, headers: headers
        }.not_to change(Book, :count)

        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response).to have_key('errors')
      end
    end
  end

  describe 'PATCH/PUT #update' do
    let!(:book) { books.first }
    let(:valid_update_attributes) { { book: { title: 'Updated Title' } } }
    let(:invalid_update_attributes) { { book: { title: '' } } }

    context 'with valid attributes' do
      it 'updates the book' do
        put "/api/v1/books/#{book.id}", params: valid_update_attributes, headers: headers
        book.reload

        expect(response).to have_http_status(:ok)
        expect(book.title).to eq('Updated Title')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the book and returns errors' do
        put "/api/v1/books/#{book.id}", params: invalid_update_attributes, headers: headers

        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response).to have_key('errors')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:book) { books.first }

    it 'deletes the book' do
      expect {
        delete "/api/v1/books/#{book.id}", headers: headers
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:see_other)
    end

    context 'when the book does not exist' do
      it 'returns not found error' do
        delete '/api/v1/books/0', headers: headers

        parsed_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(parsed_response['error']).to eq('Book not found')
      end
    end
  end
end
