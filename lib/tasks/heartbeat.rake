# frozen_string_literal: true

namespace :heartbeat do
  def param!(name, transform: nil, default: nil)
    value = ENV[name] || default

    raise ArgumentError, "Required variable #{name} not set." if value.nil?

    return value if transform.nil?

    transform.call(value)
  end

  task add: :environment do
    application = param!('APPLICATION')
    interval_seconds = param!('INTERVAL_SECONDS')
    team = param!('TEAM')

    h = Heartbeat.create!(
      application: application,
      interval_seconds: interval_seconds,
      team: team
    )

    puts "Added. Token: #{h.token}"
  end

  task token: :environment do
    application = param!('APPLICATION')

    h = Heartbeat.find_by(application: application)

    if h.nil?
      puts "No heartbeat configured for application #{application.inspect}"
      exit 1
    end

    puts "Token: #{h.token}"
  end

  task remove: :environment do
    application = param!('APPLICATION')

    h = Heartbeat.find_by(application: application)

    if h.nil?
      puts "No heartbeat configured for application #{application.inspect}"
      exit 1
    end

    h.destroy!

    puts 'Removed.'
  end
end

namespace :team_token do
  task add: :environment do
    team = param!('TEAM')

    t = TeamToken.create!(team: team)

    puts "Added. Token: #{t.token}"
  end

  task token: :environment do
    team = param!('TEAM')

    t = TeamToken.find_by(team: team)

    if t.nil?
      puts "No token configured for team #{team.inspect}"
      exit 1
    end

    puts "Token: #{t.token}"
  end

  task rotate: :environment do
    team = param!('TEAM')

    t = TeamToken.find_by(team: team)

    if t.nil?
      puts "No token configured for team #{team.inspect}"
      exit 1
    end

    t.regenerate_token

    puts "Rotated. Token: #{t.token}"
  end

  task remove: :environment do
    team = param!('TEAM')

    t = TeamToken.find_by(team: team)

    if t.nil?
      puts "No token configured for team #{team.inspect}"
      exit 1
    end

    t.destroy!

    puts 'Removed.'
  end
end
