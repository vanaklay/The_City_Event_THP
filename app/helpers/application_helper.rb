module ApplicationHelper
  def is_admin?
    redirect_to root_path unless @event.is_admin?(current_user)
  end

  def can_subscribe?
    if @event.users.select{ |user| user == current_user }.count == 0
      return true
    else
      redirect_to event_path(@event), danger: "Already subscribe !!"
    end
  end
end
