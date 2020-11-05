module AttendancesHelper
  def event
    @event = Event.find_by(id: params[:event_id])
  end
end
