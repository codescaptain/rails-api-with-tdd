FactoryBot.define do
  factory :article do
    title { "MyString" }
    content { "MyText" }
    sequence(:slug) { |n| "article-#{n}" }
  end
end
