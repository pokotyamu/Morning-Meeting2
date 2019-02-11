FactoryBot.define do
  factory :performance do
    target
    start_on { Date.today.beginning_of_week }
    value { 20_000_000 }
    sequence(:content) { |n| "content-#{n}" }
  end
end
