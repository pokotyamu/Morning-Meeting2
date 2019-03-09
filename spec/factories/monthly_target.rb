FactoryBot.define do
  factory :monthly_target do
    team
    start_on { Date.today.beginning_of_month }
    value { 100_000_000 }
  end
end
