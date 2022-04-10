FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { "MyText" }
    sequence(:slug) { |n| "article-#{n}" }
    association :user
  end
end
