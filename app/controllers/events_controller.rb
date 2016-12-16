class EventsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :deny_spammers!, only: [:create, :update, :destroy]
  invisible_captcha only: [:create, :update], on_spam: :redirect_spammers!

  def index
    @events = Event.all.ordered

    respond_to do |format|
      format.html { render :index }
      format.rss { render :layout => false }
      format.json { render :layout => false }
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render layout: false }
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: I18n.t(:'events.create.successful') }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @event = Event.find(params[:id])
    raise AuthorizationException unless current_user.can_modify?(@event)
  end

  def update
    @event = Event.find(params[:id])
    raise AuthorizationException unless current_user.can_modify?(@event)

    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: I18n.t(:'events.update.successful') }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    raise AuthorizationException unless current_user.can_modify?(@event)
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: I18n.t(:'events.destroy.successful') }
      format.json { head :no_content }
    end
  end

  private
    def event_params
      params.require(:event).permit(:name, :description, :organizer, :location, :held_at, :event_type, :url)
    end
end
