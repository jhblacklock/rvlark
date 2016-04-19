module Bookings
  # Search venicles
  class Finish
    include Service

    def call(booking)
      @booking = booking
      @vehicle = booking.vehicle
      finish
    end

    def finish
      reserve
      notify_owner
      notify_renter
    end

    def reserve
      @vehicle.reservations
              .where(on_date: @booking.check_in..@booking.check_out).update_all(state: 'unavailable')
    end

    def notify_owner
    end

    def notify_renter
    end
  end
end
