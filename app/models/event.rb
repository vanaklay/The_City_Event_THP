class Event < ApplicationRecord
  validates :start_date, presence: true, if: :future_date
  validates :duration, presence: true, numericality: { only_integer: true, greater_than: 0 }, if: :multiple_of_five?
  validates :title, presence: true, length: {in: 5..140}
  validates :description, presence: true, length: {in: 20..1000}
  validates :price, presence:true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
  validates :location, presence: true
  validates :picture, presence: true

  has_many :attendances
  has_many :users, through: :attendances
  belongs_to :admin, class_name: "User"

  has_one_attached :picture
  
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

  def is_registred?(user)
    if self.attendances
      self.attendances.find_by(user: user.id) ? true : false
    else 
      puts "n'a pas attendances"
      return
    end
  end

  def is_admin?(user)
    self.admin.id == user.id ? true : false
  end

  def amount
    self.price * 100
  end

end
