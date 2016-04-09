class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_vehicle, only: [:create, :available, :book, :price]

  def index
    @reservations = current_user.vehicles.collect do |v|
      v.reservations.select("DISTINCT ON(check_in) *").order('check_in ASC').booked
    end.flatten!
  end

  def trips
    @reservations = current_user.reservations
                                .select('DISTINCT ON(check_in) *').order('check_in ASC')
  end

  def preload
    @vehicle = Vehicle.find(params[:vehicle_id])
    today = Date.today
    reservations = @vehicle.reservations.where('on_date >= ?', today).order(:on_date)

    render json: reservations
  end

  # Make sure we get the correct date formats
  # @vehicle = Vehicle.find(1)
  # Reservations::Calculator.call(@vehicle, pickup: '04/08/16', dropoff: '04/10/16')
  def price
    ret = Reservations::Calculator.call(@vehicle, pickup: params[:pickup], dropoff: params[:dropoff])
    render json: ret
  end

  def available
    if params[:date] && !params[:date].blank?
      @reservations = @vehicle.reservations.for_2_months_starting(params[:date].to_date)
    else
      @reservations = @vehicle.reservations.for_2_months
    end
    render json: @reservations
  end

  def create
    reservation_create
    head :ok
  end

  private

  def find_vehicle
    @vehicle = Vehicle.find(params[:vehicle_id])
  end

  def reservation_create
    @vehicle.reservations.where(on_date: Date.strptime(params[:date], '%m/%d/%y')).
      first_or_create.update_attributes(on_date: Date.strptime(params[:date], '%m/%d/%y'),
                                        state: params[:state])
  end
end
