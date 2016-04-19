class Reservation < ActiveRecord::Base
  belongs_to :user
  belongs_to :vehicle
  belongs_to :booking

  attr_accessor :start_date
  attr_accessor :end_date

  scope :for_2_months, (lambda do
    where('on_date >= ? AND on_date <= ?',
      Date.today.beginning_of_month,
      Date.today.next_month.end_of_month)
  end)

  scope :for_2_months_starting, -> (date){
    where('on_date >= ? AND on_date <= ?', date.beginning_of_month, date.next_month.end_of_month)
  }

  searchkick

  scope :booked, -> { where(state: 'booked') }
  scope :unavailable, -> { where(state: 'unavailable') }
  scope :available, -> { where(state: 'available') }
  scope :special, -> { where(state: 'special') }

  def booked_on
    created_at.strftime("%B #{created_at.day.ordinalize}, %Y at %-l:%M%P")
  end
end
