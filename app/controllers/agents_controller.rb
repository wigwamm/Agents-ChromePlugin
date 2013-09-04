class AgentsController < ApplicationController
  def index
    @agents = Agent.all.sort(name: :asc)
  end

  def show
    @agent = Agent.find(params[:id])
  end
end