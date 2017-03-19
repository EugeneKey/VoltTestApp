FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:nickname) { |i| "nick-user#{i}" }
    sequence(:email) { |i| "user#{i}@mail.com" }
    password '12345678'
    password_confirmation '12345678'
  end
end
