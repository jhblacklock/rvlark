class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update]
  before_action :authenticate_user!, except: [:show, :search, :search_gate]

  def search_gate
    if place?
      dir = [@place.state.downcase, @place.city].delete_if(&:blank?).join('/')
      redirect_to "/s/#{dir}?#{search_params}"
    else
      redirect_to :not_found
    end
  end

  def search
    @vehicles = Vehicles::Search.call(params)
  end

  def new
    @vehicle = current_user.vehicles.build
  end

  def show
    @photos = @vehicle.photos
    @pickup = valid_date(params[:pickup]) || Date.today.strftime('%x')
    @dropoff = set_dropoff || next_eligible_day || (Date.today + minimum_stay.day).strftime('%x')
  end

  def valid_date(date)
    Date.strptime(date, '%m/%d/%y').strftime('%x')
  rescue
    nil
  end

  def set_dropoff
    drop_off = valid_date(params[:dropoff])
    return unless drop_off

    requested_stay = (Date.strptime(drop_off, '%m/%d/%y') - Date.strptime(@pickup, '%m/%d/%y')).to_i
    if requested_stay < minimum_stay
      day_diffs = minimum_stay - requested_stay
      (Date.strptime(drop_off, '%m/%d/%y') + day_diffs.day).strftime('%x')
    end
  end

  def minimum_stay
    @vehicle.minimum_stay || 1
  end

  def next_eligible_day
    (Date.strptime(@pickup, '%m/%d/%y') + minimum_stay.day).strftime('%x')
  rescue
    nil
  end

  def index
    @user = current_user
    @vehicles = current_user.vehicles
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)
    if @vehicle.save
      redirect_to edit_vehicle_path @vehicle, notice: 'Added!'
    else
      render :new
    end
  end

  def update
    @section = params[:section]
    if @vehicle.update(vehicle_params)
      images
      redirect_to edit_vehicle_path(@vehicle, section: @section), notice: 'Saved!'
    else
      render_tab
    end
  end

  def edit
    @section ||= params[:section]
    if current_user.id == @vehicle.user.id
      render_tab
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  private

  def search_params
    params.slice!(:formatted_address, :controller, :action).to_param
  end

  def place?
    place.present?
  end

  def place
    @place ||= Geocoder.search(params[:formatted_address]).first
  end

  def images
    return unless params[:vehicle][:images]
    params[:vehicle][:images].each do |image|
      @vehicle.photos.create(image: image)
    end
  end

  def render_tab
    case @section
    when 'photo'
      @photos = @vehicle.photos
      render :photo
    when 'location'
      @address = @vehicle.address || @vehicle.build_address
      render :location
    when 'amenities'
      render :amenities
    when 'pricing'
      @price = @vehicle.price || @vehicle.build_price
      render :pricing
    when 'availability'
      render :availability
    when 'contact'
      @user = current_user
      render :contact
    else
      render :edit
    end
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(
      :minimum_stay, :vehicle_type, :accommodates, :listing_name, :summary, :active, amenity_ids: [],
                                                                      address_attributes: [:city, :state, :zip, :address_type, :street, :apt],
                                                                      price_attributes: [:nightly_amount, :weekly_amount, :monthly_amount, :special_amount],
                                                                      user_attributes: [:id, :phone_number]
    )
  end
end
