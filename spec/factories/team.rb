FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "team-#{n}" }
    sequence(:order) { |n| n }
  end
end
