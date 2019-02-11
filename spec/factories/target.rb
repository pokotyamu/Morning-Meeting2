FactoryBot.define do
  factory :target do
    team
    sequence(:start_on) { |n| Date.today.beginning_of_month }
    value { |n| 100_000_000 }
  end
end
