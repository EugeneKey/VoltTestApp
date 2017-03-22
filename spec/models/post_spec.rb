require 'rails_helper'

RSpec.describe Post, type: :model do
  it_behaves_like 'Reportable'

  it { is_expected.to belong_to(:author).class_name('User').with_foreign_key('user_id') }

  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :user_id }

  it { is_expected.to delegate_method(:nickname).to(:author).with_prefix(true) }

  describe 'setting the value published_at' do
    subject(:post) { build(:post, published_at: nil) }
    let(:time) { Time.now }

    context 'when published_at is empty' do
      it 'save post' do
        expect { post.save! }.to change(Post, :count).by(1)
      end

      it 'setting the Time.now to published_at' do
        post.save!
        expect(post.published_at.utc.to_s).to eq time.utc.to_s
      end
    end

    it 'when published_at is valid date' do
      post.published_at = 1.day.ago.time
      post.save!
      expect(post.published_at.utc.to_s).to eq 1.day.ago.time.utc.to_s
    end
  end

  it 'scope by published_at DESC' do
    time = Time.now
    first = create(:post, published_at: 2.hours.ago.time)
    second = create(:post, published_at: time)
    create(:post, published_at: 1.hours.ago.time)

    expect(second.id).to eq Post.by_published.first.id
    expect(first.id).to eq Post.by_published.last.id
  end

end
