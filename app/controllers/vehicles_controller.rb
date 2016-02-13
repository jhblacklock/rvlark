class VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :edit, :update]
  # User must be authneticated before every controller action, except for show
  before_action :authenticate_user!, except: [:show]

  def new
    @vehicle = current_user.vehicles.build
  end

  def show
    @photos = @vehicle.photos
  end

  def index
    @vehicles = current_user.vehicles
  end

  def create
    @vehicle = current_user.vehicles.build(vehicle_params)
    if @vehicle.save
      if params[:images]
        params[:images].each do |image|
          @vehicle.photos.create(image: image)
        end
      end

      @photos = @vehicle.photos
      redirect_to edit_vehicle_path (@vehicle), notice: "Saved..."
    else
      render :new
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      if params[:images]
        params[:images].each do |image|
          @vehicle.photos.create(image: image)
        end
      end
      redirect_to edit_vehicle_path(@vehicle), notice: "Updated..."
    else
      render :edit
    end
  end

  def edit
    if current_user.id == @vehicle.user.id
     @photos = @vehicle.photos
    else
      redirect_to root_path, notice: "You don't have permission."
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(
        :home_type, :vehicle_type, :accomodates, :listing_name, :summary, :active
    )
  end
end
