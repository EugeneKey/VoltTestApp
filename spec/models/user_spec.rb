require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }

  it { is_expected.to validate_presence_of :nickname }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }
end
