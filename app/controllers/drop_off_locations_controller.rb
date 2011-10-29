class DropOffLocationsController < ApplicationController
  
  before_filter :require_admin
  
  # GET /drop_off_locations
  # GET /drop_off_locations.xml
  def index
    @stylesheet = "drop_off_locations"
    @drop_off_locations = DropOffLocation.all
    if current_user
      if current_user.is_admin(current_user)
        respond_to do |format|
          format.html # index.html.erb
          format.xml  { render :xml => @drop_off_locations }
        end
      else
        redirect_to :controller => "users", :action => "show"
      end
    else
      redirect_to :controller => "users", :action => "show"
    end    
  end

  # GET /drop_off_locations/1
  # GET /drop_off_locations/1.xml
  def show
    @drop_off_location = DropOffLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @drop_off_location }
    end
  end

  # GET /drop_off_locations/new
  # GET /drop_off_locations/new.xml
  def new
    @stylesheet = "admin_menus"
    @drop_off_location = DropOffLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @drop_off_location }
    end
  end

  # GET /drop_off_locations/1/edit
  def edit
    @stylesheet = "edit_drop_off_locations"
    @drop_off_location = DropOffLocation.find(params[:id])
  end

  # POST /drop_off_locations
  # POST /drop_off_locations.xml
  def create
    @drop_off_location = DropOffLocation.new(params[:drop_off_location])

    respond_to do |format|
      if @drop_off_location.save
        flash[:notice] = 'DropOffLocation was successfully created.'
        format.html { redirect_to(drop_off_locations_url) }
        format.xml  { render :xml => @drop_off_location, :status => :created, :location => @drop_off_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @drop_off_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /drop_off_locations/1
  # PUT /drop_off_locations/1.xml
  def update
    @drop_off_location = DropOffLocation.find(params[:id])

    respond_to do |format|
      if @drop_off_location.update_attributes(params[:drop_off_location])
        flash[:notice] = 'DropOffLocation was successfully updated.'
        format.html { redirect_to(drop_off_locations_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @drop_off_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /drop_off_locations/1
  # DELETE /drop_off_locations/1.xml
  def destroy
    @drop_off_location = DropOffLocation.find(params[:id])
    @drop_off_location.destroy

    respond_to do |format|
      format.html { redirect_to(drop_off_locations_url) }
      format.xml  { head :ok }
    end
  end
  
  def add_user_drop_off_location
    @user_drop_off_location = UserDropOffLocation.new({ :user_id => current_user.id, :drop_off_location_id => params[:id] })
    if @user_drop_off_location.save
      redirect_to account_url
    end
  end
  
  def edit_times
    @stylesheet = "edit_drop_off_times"
    @drop_off_location = DropOffLocation.find(params[:id])
  end
  
  def new_location_delivery_time
    @stylesheet = "edit_drop_off_times"
    @delivery_time = DropOffLocationTime.new
    @drop_off_location = DropOffLocation.find(params[:id])
  end
  
  def create_location_delivery_time
    @drop_off_location_time = DropOffLocationTime.new(params[:delivery_time])
    
    respond_to do |format|
      if @drop_off_location_time.save
        flash[:notice] = 'DropOffLocation was successfully created.'
        format.html { redirect_to(drop_off_locations_url) }
        format.xml  { render :xml => @drop_off_location_time, :status => :created, :location => @drop_off_location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @drop_off_location_time.errors, :status => :unprocessable_entity }
      end
    end
  end

  def schedule
    @stylesheet = "admin_menus"
  end
  
end
