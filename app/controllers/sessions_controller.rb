class SessionsController < Devise::SessionsController
  def new
    @stylesheet = "user_sessions"
    @google_fonts = "Josefin+Slab"
    super
  end

end
