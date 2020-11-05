module EventsHelper
  def event
    @event = Event.find_by(id: params[:id])
  end
end
