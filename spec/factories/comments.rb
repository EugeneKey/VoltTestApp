FactoryGirl.define do
  factory :comment do
    association :author
    body "MyString"
    published_at { Time.now }
  end
end
