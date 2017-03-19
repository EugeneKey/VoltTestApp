class Post < ApplicationRecord
  before_validation :valid_published_at

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  validates :title, :body, :user_id, presence: true
  delegate :nickname, to: :author, prefix: true

  default_scope { order(published_at: :desc) }

  private

  def valid_published_at
    self.published_at = Time.now unless published_at
  end
end
