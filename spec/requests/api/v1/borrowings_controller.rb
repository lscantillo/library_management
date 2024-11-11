require 'rails_helper'

RSpec.describe 'Api::V1::BorrowingsController', type: :request do
  let!(:user) { create(:user) }
  let!(:librarian) { create(:user, role: :librarian) }
  let!(:auth_token) { authenticate_user }
  let!(:headers) { { 'Authorization' => "Bearer #{auth_token}" } }

  let!(:book) { create(:book, available_copies: 1) }
  let!(:borrowing) { create(:borrowing, user: user, book: book, returned_at: nil) }

  describe 'GET #index' do
    context 'when fetching all borrowings' do
      it 'returns all borrowings with pagination metadata' do
        get '/api/v1/borrowings', headers: headers
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['borrowings'].size).to eq(1)
        expect(parsed_response).to have_key('pagy')
      end
    end

    context 'when fetching only active borrowings' do
      it 'returns only active borrowings' do
        get '/api/v1/borrowings', params: { active: 'true' }, headers: headers
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(parsed_response['borrowings'].size).to eq(1)
      end
    end
  end

  describe 'POST #create' do
    context 'when borrowing a book successfully' do
      let(:new_book) { create(:book, available_copies: 1) }

      it 'creates a new borrowing and updates book availability' do
        post "/api/v1/books/#{new_book.id}/borrowings", headers: headers

        parsed_response = JSON.parse(response.body)
        new_book.reload

        expect(response).to have_http_status(:ok)
        expect(parsed_response['message']).to eq('Book successfully borrowed.')
        expect(new_book.available_copies).to eq(0)
      end
    end

    context 'when borrowing a book that is unavailable' do
      it 'returns an error message' do
        post "/api/v1/books/#{book.id}/borrowings", headers: headers
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response['message']).to eq('Already have an active borrowing for this book.')
      end
    end
  end

  describe 'POST #return_book' do
    let(:borrowed_book) { create(:book, available_copies: 0) }
    let(:active_borrowing) { create(:borrowing, user: user, book: borrowed_book, returned_at: nil) }

    context 'when returning a book successfully' do
      it 'marks the book as returned and updates book availability' do
        post "/api/v1/borrowings/#{active_borrowing.id}/return", headers: headers.merge('Authorization' => "Bearer #{authenticate_user(librarian)}")

        parsed_response = JSON.parse(response.body)
        active_borrowing.reload
        borrowed_book.reload

        expect(response).to have_http_status(:ok)
        expect(parsed_response['message']).to eq('Book marked as returned.')
        expect(active_borrowing.returned_at).not_to be_nil
        expect(borrowed_book.available_copies).to eq(1)
      end
    end

    context 'when trying to return a book that is already returned' do
      it 'returns an error message' do
        active_borrowing.update(returned_at: Time.current)

        post "/api/v1/borrowings/#{active_borrowing.id}/return", headers: headers.merge('Authorization' => "Bearer #{authenticate_user(librarian)}")
        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(parsed_response['message']).to eq('Book has already been returned.')
      end
    end

    context 'when a non-librarian tries to return a book' do
      it 'returns an unauthorized message' do
        post "/api/v1/borrowings/#{active_borrowing.id}/return", headers: headers

        parsed_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(parsed_response['message']).to eq("You don't have permission to do this.")
      end
    end
  end
end
