require 'shotgun'
require 'sinatra'


scores = [
  {
    home_team: "Patriots",
    away_team: "Broncos",
    home_score: 7,
    away_score: 3
  },
  {
    home_team: "Broncos",
    away_team: "Colts",
    home_score: 3,
    away_score: 0
  },
  {
    home_team: "Patriots",
    away_team: "Colts",
    home_score: 11,
    away_score: 7
  },
  {
    home_team: "Steelers",
    away_team: "Patriots",
    home_score: 7,
    away_score: 21
  }
]

def build_teams(scores)
  teamhashes = {}
  scores.each do |game|
    if !teamhashes.has_key?(game[:home_team])
      teamhashes[game[:home_team]] = {name: game[:home_team], w: 0, l: 0}
    end
    if !teamhashes.has_key?(game[:away_team])
      teamhashes[game[:away_team]] = {name: game[:away_team], w: 0, l: 0}
    end
  end
  teamhashes
end
def add_wins_losses(teamhashes, scores)
  scores.each do |game|
    if game[:home_score] > game[:away_score]
      teamhashes[game[:home_team]][:w] += 1
      teamhashes[game[:away_team]][:l] += 1
    else
      teamhashes[game[:away_team]][:w] += 1
      teamhashes[game[:home_team]][:l] += 1
    end
  end
  teamshashwins = teamhashes
  teamsarrayswins = teamshashwins.values
end

def sorting(teamsarrayswins)
  rec_sorting(teamsarrayswins, [])
end
def rec_sorting(notranked, ranked)
  if notranked.length <= 0
    return ranked
  end
  biggest = notranked.pop
  still_notranked = []
  notranked.each do |team|
    if biggest[:w] < team[:w]
      still_notranked.push(biggest)
      biggest = team
    elsif biggest[:w] == team[:w] && biggest[:l] > team[:l]
      still_notranked.push(biggest)
      biggest = team
    else
      still_notranked.push(team)
    end
  end
  ranked.push(biggest)
  rec_sorting(still_notranked, ranked)
end

teamhashes = build_teams(scores)
teamsarrayswins = add_wins_losses(teamhashes, scores)
sorted_rankings = sorting(teamsarrayswins)

get '/' do
  erb :index
end

get '/leaderboard' do
  @sorted_rankings = sorted_rankings
  erb :leaderboard
end

set :views, File.dirname(__FILE__) + '/views'
set :public_folder, File.dirname(__FILE__) + '/public'
