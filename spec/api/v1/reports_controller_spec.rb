require 'rails_helper'

describe Api::V1::ReportsController do
  describe 'POST /by_author' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/reports/by_author", params: { format: :json }
        expect(response).to have_http_status :unauthorized
      end

      it 'returns 401 status if access_token not valid' do
        post "/api/v1/reports/by_author", params: { format: :json, access_token: '1234' }
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'authorized' do

      before do
        params = {
          start_date: 3.month.ago,
          end_date: Time.now,
          email: 'user@test.com',
          access_token: access_token.token
        }
        post "/api/v1/reports/by_author", params: params
      end

      it 'returns 200 status' do
        expect(response).to have_http_status :success
      end

      it 'returns message report generation started' do
        expect(response.body).to be_json_eql('{"message":"Report generation started"}')
      end
    end

    it 'should invoke report job' do
      params = {
        start_date: 3.month.ago,
        end_date: Time.now,
        email: 'user@test.com',
        access_token: access_token.token
      }

      expect(ReportGeneratorJob).to receive(:perform_later).with(
        params[:start_date].to_s,
        params[:end_date].to_s,
        params[:email]
      )

      post "/api/v1/reports/by_author", params: params
    end
  end
end