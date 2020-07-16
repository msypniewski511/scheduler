class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy, :accept_request, :reject_request]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join]
  before_action :event_owner!, only: [:edit,:update,:destroy]
  respond_to :html, :json

  def accept_request
    @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
    @attendance.accept!
    'Applicant Accepted' if @attendance.save
    respond_to do |format|
      if @attendance.save
        format.html { redirect_to(@event, :notice => 'Applicant Accepted') }
        format.xml  { head :ok }
      else
        format.html { redirect_to(events_path, :notice => 'Something has gone wrong , please try again.') }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
end
def reject_request
  @attendance = Attendance.find_by(id: params[:attendance_id]) rescue nil
  
  # 'Applicant Rejected' if @attendance.save
  respond_to do |format|
    if @attendance.reject!
      format.html { redirect_to(@event, :notice => 'Applicant Rejected') }
      format.xml  { head :ok }
    else
      format.html { redirect_to(events_path, :notice => 'Something has gone wrong , please try again.') }
      format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
    end
  end
  end

  # GET /events
  # GET /events.json
  def index
    if params[:tag]
      @events = Event.tagged_with(params[:tag])
    else
      @events = Event.all
    end
    @dates = Event.pluck(:start_time).map {|a| a.strftime("%Y-%m-%d") unless a==nil}
  end

  def my_events
    @events = Event.show_accepted_attendees(current_user.id)
  end

  def dates
    @dates = Event.pluck(:start_time).map {|a| a.strftime("%Y-%m-%d") unless a==nil}
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @dates }
      format.json { render json: @dates }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    # @event_owner = User.where(id: @event.organizer_id).first
    @event_owner = User.where(id: @event.organizer_id).first
    @pending_requests = Attendance.pending.where(event_id: @event.id)
    @attendees = Attendance.accepted.where(event_id: @event.id)
  end

  # GET /events/new
  def new
    @event = current_user.organized_events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.organized_events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    @attendance = Attendance.join_event(current_user.id, params[:event_id], 'request_sent')
    'Request Sent' if @attendance.save
    
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Request Sent.' }
      format.json { head :no_content, respond_with: @attendance }
    end
    # redirect_to events_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = params[:event_id] ? Event.friendly.find(params[:event_id]) : Event.friendly.find(params[:id])
      @dates = Event.pluck(:start_time).map {|a| a.strftime("%Y-%m-%d") unless a==nil}
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :start_time, :end_time, :location, :agenda, :address, :all_tags, :organizer_id)
    end

    def event_owner!
      authenticate_user!
      if @event.organizer_id != current_user.id
        redirect_to events_path
        flash[:notice] = 'You do not have enough ermissions to do this'
      end
    end

    def respond_with(attendance)
          
    respond_to do |format|
        format.html { redirect_to(@event, :notice => 'Rejected Applicant') }
        format.xml  { head :ok }
    end
  end

end
