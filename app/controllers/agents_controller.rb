class AgentsController < ApplicationController
  def index
    @agents = Agent.all.sort(name: :asc)
  end

  def show
    @agent = Agent.find(params[:id])
    # Score is the percentage of available listings
    @score = ((1 - Float(@agent.listings.where(:availability_score.gt => 0).count) / @agent.listings.count) * 100).ceil

    @location = [0, 0]
    @agent.listings.each do |listing|
      @location[0] += listing.location[0]
      @location[1] += listing.location[1]
    end
    @location = [@location[0]/@agent.listings.count, @location[1]/@agent.listings.count]
  end
end