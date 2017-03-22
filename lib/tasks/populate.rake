namespace :db do
  desc "fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'

    User.populate 10 do |user|
      user.nickname    = Faker::Name.name
      user.email       = Faker::Internet.email
      user.encrypted_password = Faker::Crypto.sha256
      user.sign_in_count = 1..300
      Post.populate 1..10 do |post|
        post.title = Populator.words(1..5).titleize
        post.body = Populator.sentences(1..5)
        post.user_id = user.id
        post.published_at = 1.years.ago..Time.now
        Comment.populate 9..20 do |comment|
          comment.post_id = post.id
          comment.user_id = user.id
          comment.body = Populator.sentences(1..3)
          comment.published_at = 1.years.ago..Time.now
        end
      end
    end
  end
end