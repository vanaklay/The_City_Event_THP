class Event < ApplicationRecord
  validates :start_date, presence: true, if: :future_date
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :multiple_of_five?
  validates :title, presence: true, length: {in: 5..140}
  validates :description, presence: true, length: {in: 20..1000}
  validates :price, presence:true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :location, presence: true

  has_many :attendances
  has_many :users, through: :attendances
  belongs_to :admin, class_name: "User"

  def multiple_of_five?
    errors.add(:duration, "should be a multiple of 5.") unless duration % 5 == 0
  end

  def future_date
    errors.add(:start_date, "Event can't be in the past") unless start_date > DateTime.now
  end

  def get_start
    self.start_date.strftime('%Y-%m-%d %H:%M')
  end

  def end_event
    date = self.start_date.to_datetime + (self.duration/1440.0)
    date.strftime('%H:%M')
  end
end
