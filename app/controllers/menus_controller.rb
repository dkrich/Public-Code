class MenusController < ApplicationController
  
  before_filter :require_admin, :except => [:show]
  
  # GET /menus
  # GET /menus.xml
  def index
    @stylesheet = "admin_menus"
    @menus = Menu.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @menus }
    end
  end
  
  # GET /menus
  # GET /menus.xml
  def admin_index
    if current_user.is_admin?(current_user)
      @stylesheet = "admin_menus"
    else
      @stylesheet = "menus"
    end
    @menus = Menu.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @menus }
    end
  end

  # GET /menus/1
  # GET /menus/1.xml
  def show
    @date_specified = params[:date]
    @stylesheet = "menus"
    @menu = Menu.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/new
  # GET /menus/new.xml
  def new
    @stylesheet = "admin_menus"
    @menu = Menu.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menu }
    end
  end

  # GET /menus/1/edit
  def edit
    @meal_type_one_name = MealType.where(:meal_type_id => 1).last.meal_type_name
    @meal_type_two_name = MealType.where(:meal_type_id => 2).last.meal_type_name
    @meal_type_three_name = MealType.where(:meal_type_id => 3).last.meal_type_name
    @stylesheet = "admin_menus"
    @menu = Menu.find(params[:id])
    @all_items = Item.find :all
    @menu_items = MenuItem.find_all_by_menu_id(@menu.id)
  end

  # POST /menus
  # POST /menus.xml
  def create
    @stylesheet = "admin_menus"
    @menu = Menu.new(params[:menu])
    @menu.meal_type = 1
    respond_to do |format|
      if @menu.save
        flash[:notice] = 'Menu was successfully created.'
        format.html { redirect_to(@menu) }
        format.xml  { render :xml => @menu, :status => :created, :location => @menu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menus/1
  # PUT /menus/1.xml
  def update
    @menu = Menu.find(params[:id])

    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        flash[:notice] = 'Menu was successfully updated.'
        format.html { redirect_to(@menu) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.xml
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy

    respond_to do |format|
      format.html { redirect_to(menus_url) }
      format.xml  { head :ok }
    end
  end
  
  def edit_menu_items
    @stylesheet = "core"
    @menu = Menu.find(params[:id])
    @menu_items = MenuItem.find_all_by_menu_id(@menu.id)
    @all_items = Item.find :all
  end
  
  def add_item_to_menu
    @menu = Menu.find(params[:id])
    @item = Item.find(params[:item_id])
    MenuItem.create(:menu_id => @menu.id, :item_id => @item.id)
    @menu_items = MenuItem.find_all_by_menu_id(@menu.id)
    respond_to do |format|
      format.html { render :controller => "menus", :action => "show" }
      format.js
    end
    #render :update do |page|
    #  page.replace_html 'menu_items', :partial => "menu_items"
    #end
  end
  
  def remove_item_from_menu
    @menu = Menu.find(params[:id])
    @item = Item.find(params[:item_id])
    @menu_item = MenuItem.find_by_menu_id_and_item_id(@menu.id, @item.id)
    @menu_item.destroy
    @menu_items = MenuItem.find_all_by_menu_id(@menu.id)
    respond_to do |format|
      format.html { render :controller => "menus", :action => "show" }
      format.js { render :action => "add_item_to_menu" }
    end
    #render :update do |page|
    #  page.replace_html 'menu_items', :partial => "menu_items"
    #end
  end
  
  def update_name
    @menu = Menu.find(params[:id])
    @menu.update_attributes(:name => params[:menu][:name], :vendor_id => params[:menu][:vendor_id], :price => params[:menu][:price])
    respond_to do |format|
      format.html { render :controller => "menus", :action => "show" }
      format.js
    end
    #render :update do |page|
    #  page.replace_html 'admin_edit_menu_title', :partial => "admin_edit_menu_title"
    #end
  end
  
  def schedule
    @stylesheet = "admin_menus"
    @meal_type_one_name = MealType.find_by_meal_type_id(1).meal_type_name
    @meal_type_two_name = MealType.find_by_meal_type_id(2).meal_type_name
    @meal_type_three_name = MealType.find_by_meal_type_id(3).meal_type_name
  end
  
  def set_menu
    DailyMenu.create( :menu_id => params[:id], :updated_by => current_user.id, :date => params[:date] )
    @menu_date = params[:date]
    render :update do |page|
      page.replace_html "calendar_menu_#{@menu_date}", :partial => "daily_menu"  
    end
  end

  def set_location_selections
    @location_selection = LocationSelection.create(:delivery_date_time => params[:date], :menu_id => params[:id], :drop_off_location_time_id => params[:drop_off_location_time_id])
    @location_selection.save
    @drop_off_location = DropOffLocation.find(DropOffLocationTime.find(params[:drop_off_location_time_id]).drop_off_location_id)
    @menu_date = params[:date]
    respond_to do |format|
      format.html { render :controller => "menus", :action => "schedule" }
      format.js
    end
  end

  def update_location_selections
    @location_selection = LocationSelection.find(params[:location_selection_id])
    @location_selection.update_attributes(:menu_id => params[:id])
    @drop_off_location = DropOffLocation.find(DropOffLocationTime.find(@location_selection.drop_off_location_time_id).drop_off_location_id)
    @menu_date = params[:date]
    respond_to do |format|
      format.html { render :controller => "menus", :action => "schedule" }
      format.js { render :action => "set_location_selections" }
    end
  end
  
  def set_selections
    @meal_type_one_name = MealType.find_by_meal_type_id(1).meal_type_name
    @meal_type_two_name = MealType.find_by_meal_type_id(2).meal_type_name
    @meal_type_three_name = MealType.find_by_meal_type_id(3).meal_type_name
    if params[:create_new] == "true"
      @daily_selection = DailySelection.create( :date => params[:date] )
      @daily_selection.save
    else
      @daily_selection = DailySelection.find_by_date(params[:date])
    end
    if params[:meal_type] == "1"
      @daily_selection.update_attributes( :menu_type_one_id => params[:id], :updated_by => current_user.id )
    elsif params[:meal_type] == "2"
      @daily_selection.update_attributes( :menu_type_two_id => params[:id], :updated_by => current_user.id )
    elsif params[:meal_type] == "3"
      @daily_selection.update_attributes( :menu_type_three_id => params[:id], :updated_by => current_user.id )
    end
    @menu_date = params[:date]
    respond_to do |format|
      format.html { render :controller => "menus", :action => "schedule" }
      format.js
    end
    #render :update do |page|
    #  page.replace_html "calendar_menu_#{@menu_date}", :partial => "daily_selections"
    #end
  end
  
  def update_menu
    @current_menu = DailyMenu.find_by_menu_id_and_date(params[:current_menu_id], params[:date])
    @current_menu.update_attributes(:menu_id => params[:id])
    @menu_date = params[:date]
    @date_unconverted = params[:date_unconverted]
    render :update do |page|
      page.replace_html "calendar_menu_#{@menu_date}", :partial => "daily_menu"  
    end
  end  
  
  def update_selections
    @meal_type_one_name = MealType.find_by_meal_type_id(1).meal_type_name
    @meal_type_two_name = MealType.find_by_meal_type_id(2).meal_type_name
    @meal_type_three_name = MealType.find_by_meal_type_id(3).meal_type_name
    @current_selections = DailySelection.find_by_date(params[:date])
    if params[:meal_type] == "1"
      @current_selections.update_attributes(:menu_type_one_id => params[:id])
    elsif params[:meal_type] == "2"
      @current_selections.update_attributes(:menu_type_two_id => params[:id])
    elsif params[:meal_type] == "3"
      @current_selections.update_attributes(:menu_type_three_id => params[:id])
    end
    @menu_date = params[:date]
    @date_unconverted = params[:date_unconverted]
    respond_to do |format|
      format.html { render :controller => "menus", :action => "schedule" }
      format.js { render :action => "set_selections" }
    end
    #render :update do |page|
    #  page.replace_html "calendar_menu_#{@menu_date}", :partial => "daily_selections"
    #end
  end
  
end
