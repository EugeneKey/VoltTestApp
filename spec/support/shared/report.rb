RSpec.shared_examples 'Reportable' do
  let(:users) { create_list(:user, 2) }
  let(:reportable_name) { described_class.name.underscore.singularize }

  it 'does have scope report data' do
    create_list(reportable_name, 3, author: users.first)
    create_list(reportable_name, 2, author: users.last)

    start_date, end_date = 3.month.ago, Time.now

    expected_hash = {["#{User.first.nickname}", "#{User.first.email}"]=>3,["#{User.last.nickname}", "#{User.last.email}"]=>2 }

    expect(described_class.get_report_data(start_date, end_date)).to eq expected_hash
  end
end
