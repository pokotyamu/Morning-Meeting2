FactoryBot.define do
  factory :announcement do
    sequence(:content) { |n| "content-#{n}" }
  end
end
