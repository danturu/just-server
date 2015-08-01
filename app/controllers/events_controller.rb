class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = Event.create!

    render json: event, status: :created
  end
end
