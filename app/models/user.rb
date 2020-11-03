class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  after_create :welcome_send
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, 
    presence:true, 
    uniqueness: true, 
    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "email adress please" }
  validates :description, presence: true

  has_many :attendances
  has_many :events, through: :attendances
  has_many :admins, foreign_key: 'admin_id', class_name: "Event", dependent: :destroy

  def welcome_send
    UserMailer.welcome_email(self).deliver_now
  end
end
