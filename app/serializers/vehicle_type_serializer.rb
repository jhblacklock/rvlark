class VehicleTypeSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slug, :tagline
end
