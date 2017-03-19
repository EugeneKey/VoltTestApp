FactoryGirl.define do
  factory :post do
    association :author
    sequence(:title) { |i| "Title Post #{i}" }
    body "Body Post"
    published_at { Time.now }
  end

  factory :invalid_post, class: 'Post' do
    association :author
    titile nil
    body nil
  end
end
