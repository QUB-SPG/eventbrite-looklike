class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.creator_id = current_user.id
    if @event.save
      flash[:success] = "Event créé!"
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    permitted_columns = params.require(:event).permit(:name, :location, :description, :date_event)
    @event.update_attributes(permitted_columns)

    redirect_to event_path(@event)
  end

  def destroy 
    @event = Event.find(params[:id])
    @event.destroy
  
    redirect_to user_path(@event.creator_id), notice: "Delete success"
  end

  def index
    @event = Event.all
  end

  def subscribe
    @event = Event.find(params[:event_id])
    @event.attendees << current_user
    redirect_to events_path
  end

  def unsubscribe
    @event = Event.find(params[:event_id])
    @event.attendees.delete(current_user)
    redirect_to events_path
  end  

  def invite
    @event = Event.find(params[:event_id])
    @users = User.all
  end

  def submit_invite
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    @event.attendees << @user
    redirect_to event_user_invited_path
  end

  def submit_uninvite
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    @event.attendees.delete(@user)
    redirect_to event_user_invited_path
  end

  private

  def event_params
    params.require(:event).permit(:location, :description, :date_event, :name)
  end
  
end
