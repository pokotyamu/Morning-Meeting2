FactoryBot.define do
  factory :announcement do
    sequence(:content) { |n| "content-#{n}" }
    start_on { Date.today }
  end
end
