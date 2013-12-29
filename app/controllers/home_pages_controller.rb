class HomePagesController < ApplicationController
  layout false

  def index
    @recommendations = Recommendation.order("created_at DESC").limit(5)
  end
end
