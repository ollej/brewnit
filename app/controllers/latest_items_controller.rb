class LatestItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @latest = LatestItems.new(current_user).all
    @event = Event.upcoming.ordered.last
  end
end
