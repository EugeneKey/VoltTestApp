require 'rails_helper'

describe Api::V1::PostsController do

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        do_request
        expect(response).to have_http_status :unauthorized
      end

      it 'returns 401 status if access_token not valid' do
        do_request(access_token: '1234')
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          do_request(access_token: access_token.token)
          expect(response).to have_http_status :created
        end

        it 'saves the new post in the database' do
          expect {
            do_request(access_token: access_token.token)
          }.to change(Post, :count).by(1)
        end

        it 'assigns created post to the user' do
          expect {
            do_request(access_token: access_token.token)
          }.to change(user.posts, :count).by(1)
        end

        %w(id title body published_at author_nickname).each do |attr|
          it "contains #{attr}" do
            do_request(access_token: access_token.token)
            expect(response.body).to be_json_eql(
              Post.first.send(attr.to_sym).to_json
            ).at_path("#{attr}")
          end
        end

        %w(created_at updated_at user_id).each do |attr|
          it "does not contains #{attr}" do
            do_request(access_token: access_token.token)
            expect(response.body).not_to have_json_path("#{attr}")
          end
        end
      end


      context 'without some attributes' do
        it 'returns 422 status code' do
          do_request(access_token: access_token.token,
                     post: attributes_for(:invalid_post))
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'do not saves the new post in the database' do
          expect {
            do_request(access_token: access_token.token,
                       post: attributes_for(:invalid_post))
          }.not_to change(Post, :count)
        end

        it 'do not assigns created post to the user' do
          expect {
            do_request(access_token: access_token.token,
                       post: attributes_for(:invalid_post))
          }.not_to change(user.posts, :count)
        end

        %w(title body).each do |attr|
          it "contains error for #{attr} in errors" do
            text_error = ["can't be blank"]
            do_request(access_token: access_token.token,
                       post: attributes_for(:invalid_post))
            expect(response.body).to be_json_eql(
              text_error.to_json
            ).at_path("errors/#{attr}")
          end
        end
      end

    end

    def do_request(options = {})
      post '/api/v1/posts',
           params: { format: :json, post: attributes_for(:post) }.merge(options)
    end

  end
end