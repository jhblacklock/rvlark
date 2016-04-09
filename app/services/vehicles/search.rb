module Vehicles
  # Search venicles
  class Search
    include Service
    include ApplicationHelper

    attr_reader :params

    def call(params)
      @params = params
      @lat = params[:lat]
      @lon = params[:lng]
      @dropoff = params[:dropoff]
      @pickup = params[:pickup]
      search
    end

    def search
      Vehicle.find(location_ids - booked_ids)
    end

    def location_ids
      Vehicle.search('*', where: { location: { near: { lat: @lat, lon: @lon }, within: '100mi' } }).results.map(&:id).uniq
    end

    def booked_ids
      Reservation.search('*', where: { on_date: { gte: pickup, lte: dropoff }, state: %w( unavailable booked ) }).results.map(&:vehicle_id).uniq
    end

    def pickup
      return unless @pickup
      DateTime.strptime(@pickup, '%m/%d/%Y')
    end

    def dropoff
      return unless @dropoff
      DateTime.strptime(@dropoff, '%m/%d/%Y')
    end
  end
end
