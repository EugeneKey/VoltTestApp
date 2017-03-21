require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :nickname }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it { is_expected.to have_attached_file(:avatar) }

  it { should validate_attachment_content_type(:avatar).
                allowing('image/png', 'image/jpeg').
                rejecting("image/gif", "application") }
  it { should validate_attachment_size(:avatar).
                less_than(3.megabytes) }
end