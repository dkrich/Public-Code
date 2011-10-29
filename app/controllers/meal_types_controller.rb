class MealTypesController < ApplicationController
  
  before_filter :require_admin
  
  # GET /meal_types
  # GET /meal_types.xml
  def index
    @stylesheet = "menus"
    @meal_types = MealType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @meal_types }
    end
  end

  # GET /meal_types/1
  # GET /meal_types/1.xml
  def show
    @stylesheet = "menus"
    @meal_type = MealType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @meal_type }
    end
  end

  # GET /meal_types/new
  # GET /meal_types/new.xml
  def new
    @stylesheet = "menus"
    @meal_type = MealType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @meal_type }
    end
  end

  # GET /meal_types/1/edit
  def edit
    @stylesheet = "menus"
    @meal_type = MealType.find(params[:id])
  end

  # POST /meal_types
  # POST /meal_types.xml
  def create
    @meal_type = MealType.new(params[:meal_type])

    respond_to do |format|
      if @meal_type.save
        flash[:notice] = 'MealType was successfully created.'
        format.html { redirect_to(@meal_type) }
        format.xml  { render :xml => @meal_type, :status => :created, :location => @meal_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @meal_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /meal_types/1
  # PUT /meal_types/1.xml
  def update
    @meal_type = MealType.find(params[:id])

    respond_to do |format|
      if @meal_type.update_attributes(params[:meal_type])
        flash[:notice] = 'MealType was successfully updated.'
        format.html { redirect_to(@meal_type) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @meal_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /meal_types/1
  # DELETE /meal_types/1.xml
  def destroy
    @meal_type = MealType.find(params[:id])
    @meal_type.destroy

    respond_to do |format|
      format.html { redirect_to(meal_types_url) }
      format.xml  { head :ok }
    end
  end
end
