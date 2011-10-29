class UsersController < ApplicationController
  
  include ApplicationHelper
  
  before_filter :require_no_user, :only => [:index, :new, :create]
  before_filter :require_user, :only => [:show, :edit, :edit_settings, :update, :change_permanent_location]
  before_filter :require_admin, :only => [:delivery_schedule, :outstanding_orders, :user_admin, :show_admin]
  
  # GET /users
  # GET /users.xml
  def index
    @stylesheet = "front_page"
    @google_fonts = "Josefin+Slab|Muli"
    @title = "Bakery Market"
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @google_fonts = "Muli|Dancing+Script|Josefin+Slab|Arvo"
    @active_page = "dashboard"
    @user = current_user
    @title = "Dashboard"
    @current_menu = "standard"
    @active_order_button = 0
    @menu_background_color = "menu_background_blue"
    @type = "standard_fare"
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).first
    if !@user_drop_off_location.blank?
      @user_drop_off_location_id = @user_drop_off_location.id
      #@order_confirmation = UserOrderConfirmation.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
      #@daily_selection = DailySelection.find_by_date(@next_five_days[@next_five_days_index].strftime("%d%m%Y"))
      #@location_selection = LocationSelection.find_by_delivery_date_time(@next_five_days[@next_five_days_index].strftime("%d%m%Y"))
      #@outstanding_order = MealOrder.where("user_id = ? AND delivery_date = ?", current_user.id, Date.parse(@delivery_date.to_s)).last
      if @user.admin == 1
        @stylesheet = "admin_menus"
        @registered_customer_count = User.all(:conditions => { :admin => 0 }).count
        @drop_off_location_count = DropOffLocation.all.count
        render "show_admin"
      else
        @stylesheet = "users"
        @user_drop_off_locations = UserDropOffLocation.where(:user_id => current_user.id)
      end
    else
      redirect_to :controller => "users", :action => "change_permanent_location"
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @stylesheet = "new_user"
    @google_fonts = "Josefin+Slab|Rock+Salt"
    @title = "Bakery Market | New User Registration"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  def edit_settings
    @user = current_user
    @drop_off_location = UserDropOffLocation.where(:user_id => current_user.id)
    unless @drop_off_location.blank?
          @drop_off_location = DropOffLocation.find(@drop_off_location.last.drop_off_location.id)
    end
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js
    end
  end

  def update_settings
          @user = current_user
          if @user.update_attributes(params[:user])
                respond_to do |format|
                  format.html { render :controller => "users", :action => "show" }
                  format.js
                end
          else
                @errors = @user.errors.full_messages
                @errors.uniq!
                flash[:error_header] = "Something went wrong."
                respond_to do |format|
                    format.html { redirect_to account_url }
                    format.js { render :action => "update_settings_failure" }
                end
          end
  end

  def finished_updating
        @drop_off_visible = false
        @selected_date = Time.zone.now
        @next_five_days = get_weekdays
        @next_five_days_index = get_next_five_day_index(@selected_date)
        @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
        #@outstanding_order = MealOrder.where("user_id = ? AND delivery_date = ?", current_user.id, Date.parse(@delivery_date.to_s)).last
        #if @outstanding_order
        @drop_off_location = DropOffLocation.find(UserDropOffLocation.where(:user_id => current_user.id).first.drop_off_location_id)
        #end
        @menu_background_color = "menu_background_blue"
        respond_to do |format|
            format.html { redirect_to account_url }
            format.js
        end
  end

  def change_permanent_location
    @stylesheet = "change_drop_off_location"
    @google_fonts = "Josefin+Slab|Arvo|Muli"
    @user = current_user
    @title = "Change Location"
    @drop_off_location = UserDropOffLocation.where(:user_id => @user.id)
    unless @drop_off_location.blank?
      @delivery_location = DropOffLocation.find(@drop_off_location.last.drop_off_location_id)
    end
    respond_to do |format|
        format.html
        format.js
    end
  end

  def update_location
    @user_drop_off_location = UserDropOffLocation.find_or_create_by_user_id(current_user.id)
    @user_drop_off_location.update_attributes(:drop_off_location_id => params[:id])
    flash[:notice] = "Your location has been updated. Please note that this will not affect any outstanding orders."
    respond_to do |format|
        format.html { redirect_to account_url }
        format.js
    end
  end

  def remove_flash
    respond_to do |format|
      format.html { redirect_to account_url }
      format.js
    end
  end

  # POST /users
  # POST /users.xml
  def create
    params[:user][:admin] = 0
    @user = User.new(params[:user])
    @user.meals_remaining = 0
    if @user.save
      UserMailer.welcome_email(@user).deliver
      respond_to do |format|
        format.html { render :controller => "users", :action => "show" }
        format.js { render :action => "user_create_success" }
      end
    else
      @errors = @user.errors.full_messages
      @errors.uniq!
      flash[:error_header] = "Something went wrong."
      flash[:error_subheader] = "The email address or password you entered was incorrect."
      respond_to do |format|
        format.html { redirect_to account_url }
        format.js { render :action => "user_create_failure" }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  def explanations
    @google_fonts = "Muli|Josefin+Sans|Dancing+Script|Josefin+Slab|Rokkitt"
    @stylesheet = "explanations"
    @active_page = "explanations"
    @title = "Bakery Market | How It Works"
  end
  
  def show_all_locations
    @stylesheet = "core"
  end
  
  def create_location_recipient
    @stylesheet = "create_location_recipient"
    @location_recipient = LocationRecipient.new
    @step = 1
  end
  
  def manage_service_plans
    @stylesheet = "core"
    @recipient = LocationRecipient.find(params[:id])
    @recipient_service_plan = UserServicePlan.where(:location_recipient_id => @recipient.id)
  end
  
  def create_recipient_record
    @location_recipient = LocationRecipient.new(params[:location_recipient])
    @location_recipient.user_id = current_user.id
    @location_recipient.meals_remaining = 0
    if @location_recipient.save
      render :update do |page|
        #page.visual_effect :move, 'step_one', :x => -1200, :duration => 1.0
        #page.delay(1.0) do
          page.visual_effect :fade, 'step_one', :duration => 0.5
          
        #end
        page.delay(0.5) do
          page.insert_html :top, 'create_recipient_step', "<div id='step_two' style='display:none'>#{render :partial => 'step_two'}</div>"
          page.visual_effect :appear, 'step_two', {:duration => 0.5, :from => 0.5, :to => 1.0 }
          #page.visual_effect :move, 'step_two', :x => -1200, :duration => 1
        end
      end
    else
      render :update do |page|
        @errors = @location_recipient.errors.full_messages
        @errors.uniq!
        page.replace_html 'recipient_create_errors', :partial => "recipient_create_errors"
      end
    end
  end
  
  def create_recipient_location
    @location_recipient = LocationRecipient.find(params[:recipient_id])
    @location_recipient.update_attributes( :drop_off_location_id => params[:id] )
    @recipient_schedule = RecipientRegularSchedule.new
    @recipient_schedule.location_recipient_id = @location_recipient.id
    @recipient_schedule.monday_scheduled = true
    @recipient_schedule.tuesday_scheduled = true
    @recipient_schedule.wednesday_scheduled = true
    @recipient_schedule.thursday_scheduled = true
    @recipient_schedule.friday_scheduled = true
    @recipient_schedule.save
    @recipient_temp_schedule = RecipientTemporarySchedule.new
    @recipient_temp_schedule.location_recipient_id = @location_recipient.id
    @recipient_temp_schedule.monday_scheduled = false
    @recipient_temp_schedule.tuesday_scheduled = false
    @recipient_temp_schedule.wednesday_scheduled = false
    @recipient_temp_schedule.thursday_scheduled = false
    @recipient_temp_schedule.friday_scheduled = false
    @recipient_temp_schedule.monday_delivered = false
    @recipient_temp_schedule.tuesday_delivered = false
    @recipient_temp_schedule.wednesday_delivered = false
    @recipient_temp_schedule.thursday_delivered = false
    @recipient_temp_schedule.friday_delivered = false
    @recipient_temp_schedule.save
    #render :update do |page|
    #  page.visual_effect :move, 'step_two', :x => -1200, :duration => 1.0
    #  page.delay(1.0) do
    #    page.visual_effect :fade, 'step_two', :duration => 0
    #  end
    #  page.delay(1.1) do
    #    page.insert_html :top, 'create_recipient_step', "<div id='step_three'>#{render :partial => 'step_three'}</div>"
    #    page.visual_effect :move, 'step_three', :x => -1200, :duration => 1
    #  end
    #end
    render :update do |page|
       page.visual_effect :fade, 'step_two', :duration => 0.5
       page.delay(0.5) do
         page.insert_html :top, 'create_recipient_step', "<div id='step_three' style='display:none'>#{render :partial => 'step_three'}</div>"
         page.visual_effect :appear, 'step_three', {:duration => 0.5, :from => 0.5, :to => 1.0 }
      end
    end
  end
  
  def start_setup
    render :update do |page|
      page.visual_effect :fade, 'step_one', :duration => 0.5
       page.delay(0.5) do
         page.replace_html "progress", :partial => "progress_bar_one"
         page.insert_html :top, 'create_user_step', "<div id='step_one' style='display:none'>#{render :partial => 'step_one_user'}</div>"
         page.visual_effect :appear, 'step_one', {:duration => 0.5, :from => 0.5, :to => 1.0 }
      end
    end
  end
  
  def create_user_location
    @user_drop_off = UserDropOffLocation.new
    @user_drop_off.user_id = current_user.id
    @user_drop_off.drop_off_location_id = params[:id]
    @user_drop_off.save
    respond_to do |format|
      format.html { redirect_to account_url }
    end
    #render :update do |page|
      #page.visual_effect :fade, 'step_one', :duration => 0.5
       #page.delay(0.5) do
         #page.replace_html "progress", :partial => "progress_bar_two"
         #page.insert_html :top, 'create_user_step', "<div id='step_two' style='display:none'>#{render :partial => 'step_two_user'}</div>"
         #page.visual_effect :appear, 'step_two', {:duration => 0.5, :from => 0.5, :to => 1.0 }
       #end
       #page.redirect_to account_url
    #end
  end
  
  def advance_to_plans
    @location_recipient = LocationRecipient.find(params[:id])
    @recipient_temp_schedule = RecipientTemporarySchedule.where(:location_recipient_id => params[:id]).last()
    @recipient_reg_schedule = RecipientRegularSchedule.where(:location_recipient_id => params[:id])
    @weekday = Time.now.wday
    if @weekday == 0 or @weekday == 6
      set_initial_temp_schedule(0, @recipient_temp_schedule, @recipient_reg_schedule)
    elsif @weekday == 1
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(0, @recipient_temp_schedule, @recipient_reg_schedule)
      else
        set_initial_temp_schedule(1, @recipient_temp_schedule, @recipient_reg_schedule)
      end
    elsif @weekday == 2
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(1, @recipient_temp_schedule, @recipient_reg_schedule)
      else
        set_initial_temp_schedule(2, @recipient_temp_schedule, @recipient_reg_schedule)
      end
    elsif @weekday == 3
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(2, @recipient_temp_schedule, @recipient_reg_schedule)
      else
        set_initial_temp_schedule(3, @recipient_temp_schedule, @recipient_reg_schedule)
      end
    elsif @weekday == 4
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(3, @recipient_temp_schedule, @recipient_reg_schedule)
      else
        set_initial_temp_schedule(4, @recipient_temp_schedule, @recipient_reg_schedule)
      end
    elsif @weekday == 5
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(4, @recipient_temp_schedule, @recipient_reg_schedule)
      end
    end
    #render :update do |page|
    #  page.visual_effect :move, 'step_three', :x => -1200, :duration => 1.0
    #  page.delay(1.0) do
    #    page.visual_effect :fade, 'step_four', :duration => 0
    #  end
    #  page.delay(1.1) do
    #    page.insert_html :top, 'create_recipient_step', "<div id='step_four'>#{render :partial => 'step_four'}</div>"
    #    page.visual_effect :move, 'step_four', :x => -1200, :duration => 1
    #  end
    #end
    render :update do |page|
       page.visual_effect :fade, 'step_three', :duration => 0.5
       page.delay(0.5) do
         page.insert_html :top, 'create_recipient_step', "<div id='step_four' style='display:none'>#{render :partial => 'step_four'}</div>"
         page.visual_effect :appear, 'step_four', {:duration => 0.5, :from => 0.5, :to => 1.0 }
      end
    end
  end
  
  def advance_to_user_plans
    @user_temp_schedule = UserTemporarySchedule.where(:user_id => current_user.id).last()
    @user_reg_schedule = UserRegularSchedule.where(:user_id => current_user.id).last()
    @weekday = Time.now.wday
    if @weekday == 0 or @weekday == 6
      set_initial_temp_schedule(0, @user_temp_schedule, @user_reg_schedule)
    elsif @weekday == 1
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(0, @user_temp_schedule, @user_reg_schedule)
      else
        set_initial_temp_schedule(1, @user_temp_schedule, @user_reg_schedule)
      end
    elsif @weekday == 2
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(1, @user_temp_schedule, @user_reg_schedule)
      else
        set_initial_temp_schedule(2, @user_temp_schedule, @user_reg_schedule)
      end
    elsif @weekday == 3
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(2, @user_temp_schedule, @user_reg_schedule)
      else
        set_initial_temp_schedule(3, @user_temp_schedule, @user_reg_schedule)
      end
    elsif @weekday == 4
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(3, @user_temp_schedule, @user_reg_schedule)
      else
        set_initial_temp_schedule(4, @user_temp_schedule, @user_reg_schedule)
      end
    elsif @weekday == 5
      if before_schedule_delivery_cutoff(Time.now)
        set_initial_temp_schedule(4, @user_temp_schedule, @user_reg_schedule)
      end
    end
    render :update do |page|
       page.visual_effect :fade, 'step_two', :duration => 0.5
       page.delay(0.5) do
         page.replace_html "progress", :partial => "progress_bar_three"
         page.insert_html :top, 'create_user_step', "<div id='step_three' style='display:none'>#{render :partial => 'step_three_user'}</div>"
         page.visual_effect :appear, 'step_three', {:duration => 0.5, :from => 0.5, :to => 1.0 }
      end
    end
  end
  
  def deliver_today
    @location_recipient = LocationRecipient.find(params[:id])
    @recipient_regular_schedule = RecipientRegularSchedule.where(:location_recipient_id => params[:id])
    @recipient_regular_schedule.update_attributes( "#{params[:day]}_scheduled" => true )
    @day = params[:day]
    render :update do |page|
      page.replace_html params[:day], :partial => "monday"
    end
  end
  
  def no_delivery_today
    @location_recipient = LocationRecipient.find(params[:id])
    @recipient_regular_schedule = RecipientRegularSchedule.where(:location_recipient_id => params[:id])
    @recipient_regular_schedule.update_attributes( "#{params[:day]}_scheduled" => false )
    @day = params[:day]
    render :update do |page|
      page.replace_html params[:day], :partial => "monday"
    end
  end
  
  
  def user_deliver_today
    @user = current_user
    @user_regular_schedule = UserRegularSchedule.where(:user_id => @user.id)
    @user_regular_schedule.update_attributes( "#{params[:day]}_scheduled" => true )
    @day = params[:day]
    render :update do |page|
      page.replace_html params[:day], :partial => "user_reg_schedule_day"
    end
  end
  
  def user_no_delivery_today
    @user = User.find(current_user.id)
    @user_regular_schedule = UserRegularSchedule.where(:user_id => @user.id)
    @user_regular_schedule.update_attributes( "#{params[:day]}_scheduled" => false )
    @day = params[:day]
    render :update do |page|
      page.replace_html params[:day], :partial => "user_reg_schedule_day"
    end
  end
  
  def destroy_location_recipient
    @location_recipient = LocationRecipient.find(params[:id])
    if @location_recipient.destroy
      render :update do |page|
        page.replace_html 'recipient_success', :partial => "recipient_success"
        page.replace_html 'recipient_info', :partial => "recipient_info"
      end
    else
      render :update do |page|
        page.replace_html 'recipient_errors', :partial => "recipient_errors"
        page.replace_html 'recipient_info', :partial => "recipient_info"
      end
    end
  end
  
  def add_temporary_delivery
    #@location_recipient = LocationRecipient.find(params[:id])
    @user_temporary_schedule = UserTemporarySchedule.where(:user_id => params[:id]).last()
    @user_temporary_schedule.update_attributes( "#{params[:day]}_scheduled" => true )
    @scheduled_today = scheduled?(@user_temporary_schedule, params[:day])
    @day = params[:day]
    @date = Date.parse(params[:date])
    render :update do |page|
      page.replace_html "next_delivery_#{params[:id]}", :partial => "next_delivery"
      page.replace_html "user_schedule_#{params[:id]}_#{params[:day]}", :partial => "deliver_today"
    end
  end
  
  def cancel_temporary_delivery
    #@location_recipient = LocationRecipient.find(params[:id])
    @user_temporary_schedule = UserTemporarySchedule.where(:user_id => params[:id]).last()
    @user_temporary_schedule.update_attributes( "#{params[:day]}_scheduled" => false )
    @scheduled_today = scheduled?(@user_temporary_schedule, params[:day])
    @day = params[:day]
    @date = Date.parse(params[:date])
    render :update do |page|
      page.replace_html "next_delivery_#{params[:id]}", :partial => "next_delivery"
      page.replace_html "user_schedule_#{params[:id]}_#{params[:day]}", :partial => "deliver_today"
    end
  end
  
  def create_user_plan
    @user = current_user
    @new_plan = UserServicePlan.create( :user_id => current_user.id, :service_plan_id => params[:id] )
    @new_plan_meals = ServicePlan.find(params[:id]).meals_included
    @user_current_meal_count = @user.meals_remaining
    @total_meals_remaining = @new_plan_meals + @user_current_meal_count
    @user.update_attribute( :meals_remaining, @total_meals_remaining )
    redirect_to account_path
  end
  
  def create_plan
    @new_plan = UserServicePlan.create( :location_recipient_id => params[:id], :service_plan_id => params[:plan] )
    @new_plan_meals = ServicePlan.find(params[:plan]).meals_included
    @recipient_current_meal_count = LocationRecipient.find(params[:id]).meals_remaining
    @total_meals_remaining = @new_plan_meals + @recipient_current_meal_count
    LocationRecipient.find(params[:id]).update_attributes( :meals_remaining => @total_meals_remaining )
    redirect_to account_path
  end
  
  def delivery_schedule
    @stylesheet = "admin_menus"
    @date = params[:date]
    #@todays_scheduled_orders = RecipientTemporarySchedule.all(:conditions => { "#{Date.parse(@date).strftime("%A").downcase}_scheduled" => true })
    #@todays_delivered_orders = RecipientTemporarySchedule.all(:conditions => { "#{Date.parse(@date).strftime("%A").downcase}_delivered" => true })
  end
  
  def outstanding_orders
    @stylesheet = "admin_menus"
    @date = params[:date]
    @date_converted = Date.strptime(@date, "%Y-%m-%d")
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@date_converted)
    @location_id = params[:id]
  end
  
  def update_delivery_statuses
    @stylesheet = "core"
    #@weekday = "#{Date.parse(params[:date]).strftime("%A").downcase}_delivered"
    MealOrder.update(params[:meal_order].keys, params[:meal_order].values)
    redirect_to :controller => :menus, :action => :schedule
  end
  
  def about_us
    @google_fonts = "Josefin+Sans|Rock+Salt|Bentham"
    @stylesheet = "about_us"
    @title = "Bakery Market | About Us"
  end
  
  def edit_recipient
    @stylesheet = "edit_recipient"
    @recipient = LocationRecipient.where(:id => params[:id])
    if @recipient
      @what_it_is = get_edit_explanation("name")
      if @recipient.user_id != current_user.id
        redirect_to account_url
      end
    else
      redirect_to account_url
    end
  end
  
  def update_recipient_name
    @recipient = LocationRecipient.find(params[:id])
    if @recipient.update_attributes(:recipient_first_name => params[:location_recipient][:recipient_first_name], :recipient_last_name => params[:location_recipient][:recipient_last_name],
                                    :phone_number_area_code => params[:location_recipient][:phone_number_area_code], :phone_number_prefix => params[:location_recipient][:phone_number_prefix], :phone_number_suffix => params[:location_recipient][:phone_number_suffix])
      @attribute = "Display name/phone number "
      @what_it_is = get_edit_explanation("name")
      render :update do |page|
        page.replace_html "update_recipient_header", :partial => "update_recipient_header"
        page.replace_html "messages", :partial => "update_recipient_success"
        page.replace_html 'update_recipient_container', :partial => "update_recipient_name"
      end
    else
      render :update do |page|
        @errors = @recipient.errors.full_messages
        @errors.uniq!
        page.replace_html "messages", :partial => "recipient_create_errors"
      end
    end
  end
  
  def switch_to_schedule
    @recipient = LocationRecipient.find(params[:id])
    @what_it_is = get_edit_explanation("schedule")
    render :update do |page|
      page.replace_html "update_recipient_container", :partial => "recipient_regular_schedule"
      page.replace_html "nav_links", :partial => "schedule_nav"
      page.replace_html "messages"
    end
  end
  
  def switch_to_name
    @recipient = LocationRecipient.find(params[:id])
    @what_it_is = get_edit_explanation("name")
    render :update do |page|
      page.replace_html "update_recipient_container", :partial => "update_recipient_name"
      page.replace_html "nav_links", :partial => "name_nav"
      page.replace_html "messages"
    end
  end
  
  def switch_to_location
    @recipient = LocationRecipient.find(params[:id])
    @what_it_is = get_edit_explanation("location")
    render :update do |page|
      page.replace_html "update_recipient_container", :partial => "update_recipient_location"
      page.replace_html "nav_links", :partial => "location_nav"
      page.replace_html "messages"
    end
  end
  
  def how
    @stylesheet = "how"
  end
  
  def update_recipient_location
    @recipient = LocationRecipient.find(params[:recipient_id])
    @recipient.update_attributes(:drop_off_location_id => params[:id])
    @attribute = "Pickup location "
    render :update do |page|
      page.replace_html "messages", :partial => "update_recipient_success"
      page.replace_html "drop_off_location", :partial => "users/select_recipient_location_partial"
    end
  end
  
  def default_schedule_explanation
    @stylesheet = "explanations"
    render :layout => false
  end
  
  def show_selections
    @user_temporary_schedule = UserTemporarySchedule.where(:user_id => current_user.id).last()
    @user_regular_schedule = UserRegularSchedule.where(:user_id => current_user.id)
    @selected_date = Date.parse(params[:date])
    @next_five_days = get_weekdays
    render :update do |page|
      page.replace_html "menu_container", :partial => "daily_menu"
    end
  end
  
  def switch_to_standard
    @current_menu = "standard"
    @menu_background_color = "menu_background_blue"
    @type = "standard_fare"
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    @outstanding_order = MealOrder.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
    #render :update do |page|
    #   page.replace_html "menu_buttons", :partial => "menu_buttons"
    #   page.replace_html "menu_background", :partial => "menu_background_blue"
    #end
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js { render :action => "switch_buttons_and_menu" }
    end
  end
  
  def switch_to_salad
    @current_menu = "salad"
    @menu_background_color = "menu_background_green"
    @type = "salad"
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    @outstanding_order = MealOrder.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js { render :action => "switch_buttons_and_menu" }
    end
    #render :update do |page|
     # page.replace_html "menu_buttons", :partial => "menu_buttons"
     # page.replace_html "menu_background", :partial => "menu_background_green"
    #end
  end
  
  def switch_to_different
    @current_menu = "different"
    @menu_background_color = "menu_background_purple"
    @type = "different"
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    @outstanding_order = MealOrder.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js { render :action => "switch_buttons_and_menu" }
    end
    #render :update do |page|
    #   page.replace_html "menu_buttons", :partial => "menu_buttons"
    #   page.replace_html "menu_background", :partial => "menu_background_purple"
    #end
  end
  
  def start_order
   #@menu_background_color = "menu_background_purple"
   #@order_started = "true"
   @selected_date = Time.zone.now
   @next_five_days = get_weekdays
   @next_five_days_index = get_next_five_day_index(@selected_date)
   @delivery_date = @next_five_days[@next_five_days_index]
   @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).first
   unless @user_drop_off_location.blank?
       #@drop_off_location_id = @user_drop_off_location.drop_off_location_id
       @drop_off_location = DropOffLocation.find(@user_drop_off_location.drop_off_location_id)
       @order_confirmation = UserOrderConfirmation.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
       if @order_confirmation.blank?
          @order_confirmation = UserOrderConfirmation.new(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s))
          @order_confirmation.save
       end
       #@active_order_button = params[:active_order_button]
       #@current_menu = "standard"
       respond_to do |format|
          format.html { render :controller => "users", :action => "show" }
          format.js
       end
   else
     respond_to do |format|
       format.js { redirect_to :controller => "users", :action => "change_permanent_location" }
     end
   end
   #render :update do |page|
   #   page.visual_effect :fade, 'location_container', :duration => 0.5
   #   page.delay(0.5) do
   #     page.replace_html "menu_buttons", :partial => "menu_buttons"
   #     page.replace_html "menu_background", :partial => "menu_background_blue"
   #     page.replace_html "meal_summary", :partial => "meal_summary"
   #   end
   # end
  end
  
  def add_meal_to_order
     @location_selection_id = params[:id]
     @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).first
     @user_drop_off_location_id = @user_drop_off_location.drop_off_location_id
     unless @user_drop_off_location.blank?
        @selected_date = Time.zone.now
        @next_five_days = get_weekdays
        @next_five_days_index = get_next_five_day_index(@selected_date)
        @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
        @location_selection = LocationSelection.find(params[:id])
        @drop_off_location_time_id = @location_selection.drop_off_location_time_id
        @order_confirmation = UserOrderConfirmation.where(:user_id => current_user.id, :drop_off_location_time_id => @drop_off_location_time_id, :delivery_date => Date.parse(@delivery_date.to_s)).first
        if @order_confirmation.blank?
          @order_confirmation = UserOrderConfirmation.new(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s), :location_selection_id => params[:id], :drop_off_location_time_id => @drop_off_location_time_id)
          @order_confirmation.save
        end
        if !@order_confirmation.confirmed
            @user_meals = current_user.meals_remaining
            @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).last
            @menu = Menu.find(@location_selection.menu_id)
            #if @user_meals - @menu.price > 0
              #@user_meals = @user_meals - @menu.price
              @drop_off_location_time = DropOffLocationTime.find(@drop_off_location_time_id)
              @outstanding_order = MealOrder.create(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s), :location_selection_id => params[:id], :drop_off_location_id => @drop_off_location_time.drop_off_location_id, :user_order_confirmation_id => @order_confirmation.id)
              @time_id = LocationSelection.find(params[:id]).drop_off_location_time_id
              #@order_confirmation = UserOrderConfirmation.where(:user_id => current_user.id, :location_selection_id => @location_selection_id).first
              @total_outstanding_orders = MealOrder.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s), :drop_off_location_id => @user_drop_off_location.id).count
              #current_user.update_attribute(:meals_remaining, @user_meals)
              respond_to do |format|
                format.html { render :controller => "users", :action => "show" }
                format.js
              end
            #else
            #  respond_to do |format|
            #    format.js { render :action => "no_credits" }
            #  end
            #end
        end
    else
       respond_to do |format|
         format.js { redirect_to :controller => "users", :action => "change_permanent_location" }
       end
    end
  end
  
  def remove_from_order
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    MealOrder.where(:user_id => current_user.id, :location_selection_id => params[:id]).destroy(:first)
    @orders_remaining = MealOrder.where(:user_id => current_user.id, :location_selection_id => params[:id]).count
    #current_user.update_attribute(:meals_remaining, current_user.meals_remaining + 1)
    @location_selection_id = params[:id]
    @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).last
    @order_confirmation = UserOrderConfirmation.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s)).last
    @user_drop_off_location_id = @user_drop_off_location.id
    #@total_outstanding_orders = MealOrder.where(:user_id => current_user.id, :delivery_date => Date.parse(@delivery_date.to_s), :drop_off_location_id => @user_drop_off_location.drop_off_location_id).count
    # After a user has reduced a meal selection by one, replace the meal selections partial and if the quantity
    # is still greater than zero, highlight that change. Otherwise, that partial will be gone.
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js
    end
  end
  
  # This method opens the editing pane.
  def change_meal_order_destination
    @outstanding_order = MealOrder.find(params[:meal_order])
    @drop_off_visible = true
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js
    end
    #render :update do |page|
    #  page.visual_effect :fade, 'menu_today', :duration => 0.5
    #  page.delay(0.5) do
    #    page.replace_html "meal_order_drop_off_location_container", :partial => "meal_order_drop_off_location"
    #  end
    #end
  end
  
  # This method actually updates the meal order location.
  def change_meal_order_location
    @drop_off_visible = false
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @outstanding_order = MealOrder.find(params[:meal_order])
    @outstanding_order.update_attributes(:drop_off_location_id => params[:id])
    @drop_off_location = DropOffLocation.find(@outstanding_order.drop_off_location_id)
    respond_to do |format|
      format.html { render :controller => "users", :action => "show" }
      format.js
    end
    #render :update do |page|
    #  page.replace_html "selection_drop_off_location", :partial => "selections_meal_order_drop_off_location"
    #  page.visual_effect :fade, 'meal_order_drop_off_location_container', :duration => 0.5
    #  page.replace_html "meal_order_drop_off_location_container", :partial => "meal_order_drop_off_location"
    #  page.visual_effect :highlight, 'selection_drop_off_location', {:duration => 1.0, :startcolor => '#ff7200', :endcolor => '#313131', :restorecolor => "313131"}
    #  page.delay(0.5) do
    #    page.visual_effect :appear,  "menu_today"
    #  end
    #end
  end
  
  def purchase_credits
    @google_fonts = "Josefin+Slab|Dancing+Script|Muli"
    @stylesheet = "users"
    @title = "Purchase Credits"
  end
  
  def send_order
    @selected_date = Time.zone.now
    @next_five_days = get_weekdays
    @next_five_days_index = get_next_five_day_index(@selected_date)
    @delivery_date = Date.parse(@next_five_days[@next_five_days_index].to_s)
    @user_drop_off_location = UserDropOffLocation.where(:user_id => current_user.id).first
    @user_drop_off_location_id = @user_drop_off_location.drop_off_location_id
    @drop_off_location = DropOffLocation.find(@user_drop_off_location.drop_off_location_id)
    @order_confirmation = UserOrderConfirmation.find(params[:id])
    @drop_off_location_time_id = DropOffLocationTime.find(@order_confirmation.drop_off_location_time_id)
    @date = @next_five_days[@next_five_days_index].strftime("%d%m%Y")
    @location_selections = LocationSelection.find_all_by_drop_off_location_time_id_and_delivery_date_time(@drop_off_location_time_id, @date)
    @user_meals = current_user.meals_remaining
    @meal_quantity = 0
    @total_price = 0
    @location_selections.each do |location_selection|
      @meal_quantity = @meal_quantity + MealOrder.where(:user_id => current_user.id, :location_selection_id => location_selection.id).count
      @total_price = @total_price + Menu.find(location_selection.menu_id).price
    end
    if @user_meals - @total_price >= 0
      @user_meals = @user_meals - @total_price
      @total_credits_used = current_user.total_credits_used + @total_price
      current_user.update_attributes(:meals_remaining => @user_meals, :total_credits_used => @total_credits_used)
      if !@order_confirmation.blank?
            if !@order_confirmation.confirmed?
                @order_confirmation.update_attributes( :confirmed => true )
                @display_add_to_order_button = false
                UserMailer.meal_order_summary(current_user, @date, @drop_off_location_time_id, @meal_quantity).deliver
            end
      else
            @errors = "You haven't made a selection!"
      end
      respond_to do |format|
        format.html { render :controller => "users", :action => "show" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :controller => "users", :action => "show" }
        format.js { render :action => "no_credits" }
      end
    end
  end

  def user_admin
    @stylesheet = "admin_menus"
    @users = User.where(:admin => 0).all
  end

  def view_user_orders
    @stylesheet = "admin_menus"
    @user = User.find(params[:id])
    @user_order_confirmations = UserOrderConfirmation.where(:user_id => @user.id, :confirmed => true).all
  end

  def request_location
    @stylesheet = "change_drop_off_location"
    @title = "Request a Location"
    @google_fonts = "Muli"
  end

  def send_location_request
    @name = params[:name]
    @address = params[:address]
    @city = params[:city]
    @state = params[:state]
    @comments = params[:comments]
    UserMailer.request_location(@name, @address, @city, @state, @comments).deliver
    flash[:notice] = "Thanks for your interest! If you left us an email address, we'll get back to you shortly."
    redirect_to root_url
  end
  
end
