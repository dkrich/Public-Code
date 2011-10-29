class ItemsController < ApplicationController
  
  before_filter :require_admin
  
  # GET /items
  # GET /items.xml
  def index
    @stylesheet = "items"
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    @stylesheet = "items"
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @stylesheet = "items"
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @stylesheet = "items"
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])
    if @item.save
      flash[:notice] = 'Item was successfully created.'
      redirect_to items_url
    else
      format.html { render :action => "new" }
      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @stylesheet = "items"
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        flash[:notice] = 'Item was successfully updated.'
        format.html { redirect_to({:controller => "items"}) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
    end
  end
end
