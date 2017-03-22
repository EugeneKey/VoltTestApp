class Post < ApplicationRecord
  include Reportable

  before_validation :valid_published_at

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, dependent: :destroy
  validates :title, :body, :user_id, presence: true
  delegate :nickname, to: :author, prefix: true

  scope :by_published, -> { order(published_at: :desc) }

  private

  def valid_published_at
    self.published_at = Time.now unless published_at
  end
end
