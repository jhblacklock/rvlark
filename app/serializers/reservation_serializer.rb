class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :on_date, :state
end
