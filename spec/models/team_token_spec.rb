# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamToken do
  it 'generates a token on create' do
    expect(Fabricate(:team_token).token).to be_present
  end

  it 'requires a team' do
    expect(TeamToken.new(team: nil)).not_to be_valid
    expect(TeamToken.new(team: '')).not_to be_valid
  end

  it 'allows only one token per team' do
    Fabricate(:team_token, team: 'hitobito')

    expect(TeamToken.new(team: 'hitobito')).not_to be_valid
  end

  describe '.authenticates?' do
    let!(:team_token) { Fabricate(:team_token, team: 'hitobito', token: 'teamtoken') }

    it 'accepts the token of the team' do
      expect(TeamToken.authenticates?('hitobito', 'teamtoken')).to be true
    end

    it 'rejects another token' do
      expect(TeamToken.authenticates?('hitobito', 'wrong')).to be false
    end

    it 'rejects the token of another team' do
      expect(TeamToken.authenticates?('puzzle', 'teamtoken')).to be false
    end

    it 'rejects a blank team' do
      expect(TeamToken.authenticates?(nil, 'teamtoken')).to be false
      expect(TeamToken.authenticates?('', 'teamtoken')).to be false
    end

    it 'rejects a blank candidate' do
      expect(TeamToken.authenticates?('hitobito', nil)).to be false
      expect(TeamToken.authenticates?('hitobito', '')).to be false
    end
  end
end
