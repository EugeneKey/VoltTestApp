class Comment < ApplicationRecord
  include Reportable

  belongs_to :author, class_name: 'User', foreign_key: 'user_id'
  belongs_to :post, foreign_key: 'post_id'

  validates :body, :published_at, presence: true

end
