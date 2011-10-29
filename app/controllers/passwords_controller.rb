class PasswordsController < Devise::PasswordsController
  
  def new
    @stylesheet = "users"
    super
  end

  def create
    @stylesheet = "users"
    super
  end

end