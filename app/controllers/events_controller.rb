class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :edit]
  before_action :is_admin?, only: [:edit]
  
  def index
    @events = Event.all.reverse
    @previous_events = Event.all.slice(-3..-1).reverse
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.admin = current_user
    if @event.save
      flash[:notice] = "Event create"
      redirect_to event_path(@event.id)
    else
      flash.now[:alert] = "We cannot create this event for this reason(s) :"
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @events = Event.where(admin: @event.admin)
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      flash[:notice] = "Event updated in DB"
      redirect_to event_path(@event.id)
    else
      flash.now[:alert] = "We cannot updated this event for this reason(s) :"
      render :edit
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    redirect_to user_path(current_user.id)
  end

  private
  def event_params
    event_params = params.require(:event).permit(:start_date, :duration, :title, :description, :price, :location)
    event_params[:start_date] = str_to_datetime(event_params[:start_date])
    event_params[:duration] = event_params[:duration].to_i 
    event_params[:price] = event_params[:price].to_i 
    return event_params
  end

  def str_to_datetime(str)
    DateTime.parse(str+'+01:00')
  end

  def is_admin?
    @event = Event.find_by(id: params[:id])
    redirect_to root_path unless @event.is_admin?(current_user)
  end
end
