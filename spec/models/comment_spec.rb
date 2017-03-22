require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_behaves_like 'Reportable'

  it { is_expected.to belong_to(:post).with_foreign_key('post_id') }
  it { is_expected.to belong_to(:author).class_name('User').with_foreign_key('user_id') }

  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :published_at }
end
