module Reportable
  extend ActiveSupport::Concern

  included do
    belongs_to :author, class_name: 'User', foreign_key: 'user_id'

    delegate :nickname, to: :author, prefix: true

    scope :get_report_data, ->(start_date, end_date) {
      where(published_at: start_date..end_date).joins(:author).group('users.nickname','users.email').count
    }
  end
end