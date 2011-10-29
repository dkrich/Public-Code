class RegistrationsController < Devise::RegistrationsController

  def new
    @stylesheet = "new_user"
    @title = "Bakery Market | New User"
    @google_fonts = 'Rock+Salt|Josefin+Slab|Arvo'
    super
  end

  #def create
  #  @stylesheet = "new_user"
  #  @title = "Bakery Market | New User"
  #  @google_fonts = 'Rock+Salt|Josefin+Slab|Arvo'
  #  super
  #  resource.first_name = params[:user][:first_name]
  #end

  def create

    @stylesheet = "new_user"
    @title = "Bakery Market | New User"
    @google_fonts = 'Rock+Salt|Josefin+Slab|Arvo'
    build_resource
    resource.meals_remaining = 0
    resource.first_name = params[:user][:first_name]
    resource.last_name = params[:user][:last_name]
    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        #respond_with resource, :location => redirect_location(resource_name, resource)
        UserMailer.welcome_email(@user).deliver
        respond_to do |format|
          format.html { render :controller => "users", :action => "show" }
          format.js { render :action => "user_create_success" }
        end
      else
        set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s if is_navigational_format?
        expire_session_data_after_sign_in!
        #respond_with resource, :location => after_inactive_sign_up_path_for(resource)
        UserMailer.welcome_email(@user).deliver
        respond_to do |format|
          format.html { render :controller => "users", :action => "show" }
          format.js { render :action => "user_create_success" }
        end
      end
    else
      clean_up_passwords(resource)
      @errors = resource.errors.full_messages
      @errors.uniq!
      flash[:error_header] = "Something went wrong."
      flash[:error_subheader] = "The email address or password you entered was incorrect."
      respond_to do |format|
        format.html { redirect_to account_url }
        format.js { render :action => "user_create_failure" }
      end
      #respond_with_navigational(resource) { render_with_scope :new }
    end
  end

end
