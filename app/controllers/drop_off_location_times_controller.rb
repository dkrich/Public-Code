class DropOffLocationTimesController < ApplicationController
  # GET /drop_off_location_times
  # GET /drop_off_location_times.xml
  def index
    @stylesheet = "edit_drop_off_times"
    @drop_off_location_times = DropOffLocationTime.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @drop_off_location_times }
    end
  end

  # GET /drop_off_location_times/1
  # GET /drop_off_location_times/1.xml
  def show
    @drop_off_location_time = DropOffLocationTime.find(params[:id])
    @stylesheet = "edit_drop_off_times"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @drop_off_location_time }
    end
  end

  # GET /drop_off_location_times/new
  # GET /drop_off_location_times/new.xml
  def new
    @stylesheet = "edit_drop_off_times"
    @drop_off_location = DropOffLocation.find(params[:drop_off_location_id])
    @drop_off_location_time = DropOffLocationTime.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @drop_off_location_time }
    end
  end

  # GET /drop_off_location_times/1/edit
  def edit
    @stylesheet = "edit_drop_off_times"
    @drop_off_location_time = DropOffLocationTime.find(params[:id])
    @location = DropOffLocation.find(@drop_off_location_time.drop_off_location_id)
  end

  # POST /drop_off_location_times
  # POST /drop_off_location_times.xml
  def create
    @drop_off_location_time = DropOffLocationTime.new(params[:drop_off_location_time])
    if @drop_off_location_time.save
      respond_to do |format|
        format.html { redirect_to :controller => "drop_off_locations", :action => "index" }
      end
    end
  end

  # PUT /drop_off_location_times/1
  # PUT /drop_off_location_times/1.xml
  def update
    @drop_off_location_time = DropOffLocationTime.find(params[:id])

    respond_to do |format|
      if @drop_off_location_time.update_attributes(params[:drop_off_location_time])
        flash[:notice] = 'DropOffLocationTime was successfully updated.'
        format.html { redirect_to(@drop_off_location_time) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @drop_off_location_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drop_off_location_times/1
  # DELETE /drop_off_location_times/1.xml
  def destroy
    @drop_off_location_time = DropOffLocationTime.find(params[:id])
    @drop_off_location_time.destroy

    redirect_to :controller => "drop_off_locations", :action => "index"
  end
end
