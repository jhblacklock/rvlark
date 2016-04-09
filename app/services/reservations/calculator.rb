module Reservations
  # Search venicles
  class Calculator
    include Service
    include ApplicationHelper
    include ActionView::Helpers::NumberHelper

    attr_reader :params

    def call(vehicle, opts = {})
      @vehicle = vehicle
      @dropoff = opts[:dropoff]
      @pickup = opts[:pickup]
      calculate
    end

    def calculate
      return { dropOff: @dropoff, pickUp: @pickup, datesAvailable: false } unless dates_available

      { totalNights: num_of_nights, dropOff: @dropoff, pickUp: @pickup, rentalAmount: c(rental_amount),
        totalAmount: c(total_amount), serviceFee: c(service_fee)
      }
    end

    def dates_available
      @reservations = @vehicle.reservations.available.where('on_date >= ? AND on_date <= ?', @pickup, @dropoff)
      @reservations.count == num_of_days
    end

    def rental_amount
      num_of_nights * vehicle_amount
    end

    def vehicle_amount
      return @vehicle.nightly_amount if num_of_nights <= 7

      num_of_nights >= 30 ? @vehicle.monthly_amount : @vehicle.weekly_amount
    end

    def total_amount
      rental_amount + service_fee
    end

    def service_fee
      # @vehicle.service_fee
      35
    end

    def num_of_nights
      @num_of_nights ||= (checkout_date - checkin_date).to_i
    end

    def num_of_days
      num_of_nights + 1
    end

    def checkin_date
      Date.strptime(@pickup, '%m/%d/%y')
    end

    def checkout_date
      Date.strptime(@dropoff, '%m/%d/%y')
    end

    def c(amount)
      number_to_currency(amount)
    end
  end
end
