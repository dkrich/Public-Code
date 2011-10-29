class PasswordResetsController < ApplicationController
  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :require_no_user
  
  def new
    @stylesheet = "password_resets"
    @title = "Bakery Market | Reset Your Password"
    render
  end
  
  def create
    @stylesheet = "password_resets"
    @user = User.where(:email => params[:email]).last
    if @user
      @user.send_password_reset_instructions!
      respond_to do |format|
        format.html { render account_url }
        format.js
      end
      #flash[:notice] = "Instructions to reset your password have been emailed to you."
      #render :update do |page|
      #  page.redirect_to login_path
      #end
    else
      respond_to do |format|
        format.html { render account_url }
        format.js { render :action => "password_reset_failure" }
      end
      #flash[:notice] = "No user was found with that email address."
      #render :update do |page|
      #  page.replace_html :reset_password_errors, :partial => "reset_password_errors"
      #end
    end
  end
  
  def edit
    @stylesheet = "password_resets"
    render
  end
  
  def update
    @stylesheet = "password_resets"
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Password successfully updated."
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  private 
  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
      "If you are having issues try copying and pasting the URL " +  
      "from your email into your browser or restarting the " +  
      "reset password process."  
      redirect_to root_url
    end
  end
  
end
