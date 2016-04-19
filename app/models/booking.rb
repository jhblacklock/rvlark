class Booking < ActiveRecord::Base
  has_many :reservations
  belongs_to :user
  belongs_to :vehicle
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

  state_machine :state, initial: :pending do
    after_transition on: :accept, do: :book
    after_transition on: :decline, do: :release

    event :accept do
      transition all => :accepted
    end

    event :decline do
      transition all => :declined
    end
  end

  def book
    vehicle.reservations.where(on_date: check_in..check_out).update_all(state: 'booked')
  end

  def release
    vehicle.reservations.where(on_date: check_in..check_out).update_all(state: 'available')
  end

  def duration
    "#{check_in.to_s(:long_ordinal)} - #{check_out.to_s(:long_ordinal)}"
  end

  def rental_amount=(val)
    return val if val.is_a?(Float)

    write_attribute(:rental_amount, val.delete('$').to_f)
  end

  def total_amount=(val)
    return val if val.is_a?(Float)

    write_attribute(:total_amount, val.delete('$').to_f)
  end

  def service_fee=(val)
    return val if val.is_a?(Float)

    write_attribute(:service_fee, val.delete('$').to_f)
  end

  def check_in=(val)
    return val if val.is_a? Date

    write_attribute(:check_in, Date.strptime(val, '%m/%d/%y'))
  end

  def check_out=(val)
    return val if val.is_a? Date

    write_attribute(:check_out, Date.strptime(val, '%m/%d/%y'))
  end
end
