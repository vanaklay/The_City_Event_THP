class AttendancesController < ApplicationController
  include AttendancesHelper
  before_action :event, only: [:index, :create, :new]
  before_action :authenticate_user!
  before_action :is_admin?, only: [:index]
  before_action :can_subscribe?
  
  def index
    @attendances = @event.attendances
  end

  def new
    @attendance = Attendance.new
  end

  def create
    # Amount in cents
    @amount = @event.amount
    customer = Stripe::Customer.create({
      email: params[:stripeEmail],
      source: params[:stripeToken],
    })
  
    begin
      charge = Stripe::Charge.create({
        customer: customer.id,
        amount: @amount,
        description: 'Rails Stripe customer',
        currency: 'EUR',
      })
      Attendance.create(event: @event, user: current_user, stripe_customer_id: customer.id)
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_attendance_path
    end
  end

end
