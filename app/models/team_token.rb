# frozen_string_literal: true

# A token that is valid for every Heartbeat of a team. This allows one shared
# secret to signal many applications, e.g. a CI matrix build that runs the
# test suites of all repositories of a project.
class TeamToken < ApplicationRecord
  has_secure_token

  validates :team, presence: true, uniqueness: true

  def self.authenticates?(team, candidate)
    return false if team.blank? || candidate.blank?

    team_token = find_by(team: team)

    team_token.present? &&
      ActiveSupport::SecurityUtils.secure_compare(team_token.token, candidate)
  end
end
