FactoryBot.define do
  factory :item do
    name { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4) }
    unit_price { Faker::Commerce.price }
    merchant
  end
end
