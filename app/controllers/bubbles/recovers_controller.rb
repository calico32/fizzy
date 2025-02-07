class Bubbles::RecoversController < ApplicationController
  include BubbleScoped, BucketScoped

  def create
    if bubble = Bubble.recover_recently_abandoned_creation(Current.user)
      redirect_to bubble
    end
  end
end
