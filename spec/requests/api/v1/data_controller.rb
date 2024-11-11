require 'rails_helper'

RSpec.describe 'Api::V1::DataController', type: :request do
  let!(:user) { create(:user) }
  let!(:auth_token) { authenticate_user }

  before do
    # Add the token to headers for all requests
    @headers = { 'Authorization' => "Bearer #{auth_token}" }
  end

  describe 'GET #genres' do
    let!(:genres) { create_list(:genre, 5) }

    it 'returns all genres with pagination metadata' do
      get '/api/v1/data/genres', headers: @headers
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response['genres'].size).to eq(5)
      expect(parsed_response).to have_key('pagy')
    end
  end

  describe 'GET #authors' do
    let!(:authors) { create_list(:author, 5) }

    it 'returns all authors with pagination metadata' do
      get '/api/v1/data/authors', headers: @headers
      parsed_response = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(parsed_response['authors'].size).to eq(5)
      expect(parsed_response).to have_key('pagy')
    end
  end
end
