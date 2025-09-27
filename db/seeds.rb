srand(8675)

def mac_address
  6.times.map { "%02x" % rand(256) }.join(":")
end

companies = {
  'ACME' => {
    conveyors: %w[1 2],
    sections: %w[A B C],
    sides: [ 1, 2 ]
  },
  'DEMO' => {
    conveyors: %w[1 2],
    sections: %w[A B],
    sides: [ 1 ]
  }
}

companies.each do |name, config|
  puts "Creating company #{name}"
  company = Company.create(name:)
  puts "  company created"
  puts "Building sensors"
  config => { conveyors:, sections:, sides: }
  conveyors.each do |conveyor|
    sections.each do |section|
      sides.each do |side|
        Sensor.create!(
          company:,
          name: "Conveyor #{conveyor}#{section}-#{side}",
          code: mac_address
        )
      end
    end
  end
end

puts "  #{Sensor.count} sensors created"

puts "Building metrics"
# Create metrics
metric_kinds = %w[signal speed]

max_past_time = 27.hours

Sensor.all.pluck(:code).each do |code|
  metric_kinds.each do |metric_kind|
    rand(150..225).times do
      metric_timestamp = rand(0..max_past_time).seconds.ago

      value = rand(0.0..100.0).round(2)
      Metric.create!(
        source: code,
        name: metric_kind,
        value:,
        created_at: metric_timestamp,
        updated_at: metric_timestamp)
    end
  end
end
puts "  #{Metric.count} metrics created"

puts "Bulding users"
Company.all.each do |company|
  5.times do |idx|
    user = User.create email_address: "user#{idx + 1}@#{company.name}.com",
                     password: "password"
    puts "  user #{user.email_address} created"
  end
end
