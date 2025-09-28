FactoryBot.define do
  factory :metric do
    transient do
      sensor_instance { nil }
    end

    source do
      if sensor_instance
        sensor_instance.code
      else
        create(:sensor).code
      end
    end
    name { %w[pressure rpm temperature].sample }
    value { rand(1.0..100.0).round(2) }

    trait :pressure do
      name { "pressure" }
      value { rand(0.0..120.0).round(2) }
    end

    trait :rpm do
      name { "rpm" }
      value { rand(0.0..1000.0).round(2) }
    end
  end
end