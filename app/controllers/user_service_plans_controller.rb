class UserServicePlansController < ApplicationController
  
  # GET /user_service_plans
  # GET /user_service_plans.xml
  def index
    @user_service_plans = UserServicePlan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_service_plans }
    end
  end

  # GET /user_service_plans/1
  # GET /user_service_plans/1.xml
  def show
    @user_service_plan = UserServicePlan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_service_plan }
    end
  end

  # GET /user_service_plans/new
  # GET /user_service_plans/new.xml
  def new
    @stylesheet = "core"
    @user_service_plan = UserServicePlan.new
  end

  # GET /user_service_plans/1/edit
  def edit
    @user_service_plan = UserServicePlan.find(params[:id])
  end

  # POST /user_service_plans
  # POST /user_service_plans.xml
  def create
    @user_service_plan = UserServicePlan.new(params[:user_service_plan])

    respond_to do |format|
      if @user_service_plan.save
        flash[:notice] = 'UserServicePlan was successfully created.'
        format.html { redirect_to(@user_service_plan) }
        format.xml  { render :xml => @user_service_plan, :status => :created, :location => @user_service_plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_service_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_service_plans/1
  # PUT /user_service_plans/1.xml
  def update
    @user_service_plan = UserServicePlan.find(params[:id])

    respond_to do |format|
      if @user_service_plan.update_attributes(params[:user_service_plan])
        flash[:notice] = 'UserServicePlan was successfully updated.'
        format.html { redirect_to(@user_service_plan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_service_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_service_plans/1
  # DELETE /user_service_plans/1.xml
  def destroy
    @user_service_plan = UserServicePlan.find(params[:id])
    @user_service_plan.destroy

    respond_to do |format|
      format.html { redirect_to(user_service_plans_url) }
      format.xml  { head :ok }
    end
  end
end
