class PagesController < ApplicationController
  def home
    @destinations = Destination.limit(3)
    @vehicle_types = VehicleType.limit(2)
  end
end
