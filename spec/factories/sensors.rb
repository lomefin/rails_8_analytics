FactoryBot.define do
  factory :sensor do
    name { Faker::Device.model_name }
    code { Faker::Alphanumeric.alpha(number: 8).upcase }
    metrics_count { 0 }
    company
  end
end