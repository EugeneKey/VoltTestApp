require 'rails_helper'

RSpec.describe ReportGeneratorJob, type: :job do
  let(:users) {create_list(:user, 2)}
  let!(:posts) { create_list(:post, 2, author: users.first) }
  let!(:comments) { create_list(:comment, 21, author: users.last) }

  it 'send report mail' do
    start_date, end_date = 3.month.ago, Time.now
    email = 'test@user.com'

    report_data = [["#{User.last.nickname}", "#{User.last.email}", 0, 21], ["#{User.first.nickname}", "#{User.first.email}", 2, 0]]

    expect(ReportMailer).to receive(:report).with(report_data, email, start_date.utc.to_s, end_date.utc.to_s).and_call_original
    ReportGeneratorJob.perform_now(start_date, end_date, email)
  end

  it 'send error mail' do
    start_date, end_date = "notDate", Time.now
    email = 'test@user.com'
    params_error = [start_date.to_s,end_date.to_s]

    expect(ReportMailer).to receive(:error).with(params_error, email).and_call_original
    ReportGeneratorJob.perform_now(start_date, end_date, email)
  end
end