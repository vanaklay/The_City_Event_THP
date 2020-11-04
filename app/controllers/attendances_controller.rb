class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :is_admin?, only: [:index]
  before_action :can_subscribe?
  
  

  def index
    @event = Event.find_by(id: params[:event_id])
    @attendances = @event.attendances
  end

  def new
    @attendance = Attendance.new
    @event = Event.find_by(id: params[:event_id])
  end

  def create
    # Amount in cents
    @event = Event.find_by(id: params[:event_id])
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

  private

  def registred
    @event = Event.find_by(id: params[:event_id])
    @event.attendances.find_by(user: current_user) ? false : true
  end

  def can_subscribe?
    @event = Event.find_by(id: params[:event_id])
    if @event.users.select{ |user| user == current_user }.count == 0
      return true
    else
      redirect_to event_path(@event), danger: "Already subscribe !!"
    end
  end

  def is_admin?
    @event = Event.find_by(id: params[:event_id])
    redirect_to root_path unless @event.is_admin?(current_user) 
  end
end
