class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy, :accept, :decline]
  before_action :deep_underscore_params!, only: [:create]

  def index
    @bookings = scope.bookings

    respond_to do |format|
      format.html
      format.json { render json: @bookings }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @booking }
    end
  end

  def create
    @booking = scope.bookings.new(full_params)

    respond_to do |format|
      if @booking.save
        Bookings::Finish.call(@booking)

        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render json: @booking, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :no_content }
    end
  end

  def accept
    return unless @booking.owner == current_user

    @booking.accept
    respond_to do |format|
      format.html { redirect_to @booking }
      format.json { head :no_content }
    end
  end

  def decline
    return unless @booking.owner == current_user

    @booking.decline
    respond_to do |format|
      format.html { redirect_to @booking }
      format.json { head :no_content }
    end
  end

  private

  def full_params
    @vehicle = Vehicle.find(params[:vehicle_id])
    booking_params.merge!(vehicle_id: params[:vehicle_id], owner_id: @vehicle.user_id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :total_amount, :rental_amount, :service_fee)
  end

  def scope
    current_user
  end
end
