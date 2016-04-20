class VehicleTypesController < ApplicationController
  before_action :set_vehicle_type, only: [:show, :edit, :update, :destroy]

  # GET /vehicle_types
  # GET /vehicle_types.json
  def index
    @vehicle_types = VehicleType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vehicle_types }
    end
  end

  # GET /vehicle_types/1
  # GET /vehicle_types/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vehicle_type }
    end
  end

  # GET /vehicle_types/new
  def new
    @vehicle_type = VehicleType.new
  end

  # GET /vehicle_types/1/edit
  def edit
  end

  def images
    return unless params[:vehicle_type][:images]
    params[:vehicle_type][:images].each do |image|
      @vehicle_type.photos.create(image: image)
    end
  end


  # POST /vehicle_types
  # POST /vehicle_types.json
  def create
    @vehicle_type = VehicleType.new(vehicle_type_params)

    respond_to do |format|
      if @vehicle_type.save
        images

        format.html { redirect_to @vehicle_type, notice: 'Vehicle type was successfully created.' }
        format.json { render json: @vehicle_type, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @vehicle_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicle_types/1
  # PATCH/PUT /vehicle_types/1.json
  def update
    respond_to do |format|
      if @vehicle_type.update(vehicle_type_params)
        images

        format.html { redirect_to @vehicle_type, notice: 'Vehicle type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @vehicle_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicle_types/1
  # DELETE /vehicle_types/1.json
  def destroy
    @vehicle_type.destroy
    respond_to do |format|
      format.html { redirect_to vehicle_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle_type
      @vehicle_type = VehicleType.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_type_params
      params.require(:vehicle_type).permit(:name, :description, :slug, :tagline)
    end
end
