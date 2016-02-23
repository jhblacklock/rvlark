class PhotosController < ApplicationController
  def destroy
    @photo = Photo.find(params[:id])
    vehicle = @photo.vehicle

    @photo.destroy
    @photos = Photo.where(vehicle_id: vehicle.id)

    respond_to :js
  end
end
