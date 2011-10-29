class VendorProfilesController < ApplicationController
  before_filter :require_admin, :except => [:show]

  def show
    @stylesheet = "vendors"
    @google_fonts = "Arvo|Muli|Josefin+Slab"
    @vendor_profile = VendorProfile.find_by_vendor_id(params[:id])
    @vendor = Vendor.find(@vendor_profile.vendor_id)
    @title = @vendor.name
  end
  
  def create
    @vendor_profile = Vendor.new(params[:vendor_profile])
    respond_to do |format|
      if @vendor_profile.save
        format.html { redirect_to(@vendor_profile, :notice => 'Vendor profile was successfully created.') }
        format.xml  { render :xml => @vendor_profile, :status => :created, :location => @vendor }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vendor_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @vendor_profile = VendorProfile.find_by_vendor_id(params[:vendor_profile][:vendor_id])
    respond_to do |format|
      if @vendor_profile.update_attributes(params[:vendor_profile])
        format.html { redirect_to(@vendor_profile, :notice => 'Vendor profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vendor_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @vendor = Vendor.find(params[:id])
    @vendor_profile = VendorProfile.find_or_create_by_vendor_id(@vendor.id)
    @stylesheet = "admin_menus"
  end

end
