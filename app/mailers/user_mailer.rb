class UserMailer < ActionMailer::Base
  default :from => "noreply@bakerymarket.com"
  default_url_options[:host] = "localhost:3000"

   def password_reset_instructions(user)
     @user = user
     #attachments.inline['bakery_market_blue.png'] = File.read('public/images/bakery_market_blue.png')
     @url = edit_password_reset_url(user.perishable_token)
     mail(:to => user.email,
          :subject => "Bakery Market - Password Reset Instructions")
   end

   def welcome_email(user)
     @user = user
     mail(:to => user.email,
          :subject => "Welcome to Bakery Market!")
   end

   def purchase_complete(user, service_plan)
     @user = user
     @service_plan = service_plan
     mail(:to => user.email,
          :subject => "Your Order Summary")
   end

   def request_location(name, address, city, state, comments)
     @name = name
     @address = address
     @city = city
     @state = state
     @comments = comments
     mail(:to => "dkrich@gmail.com",
          :subject => "New Location Request")
   end

   def meal_order_summary(user, date, drop_off_location_time_id, order_quantity)
     @user = user
     @location_selections = LocationSelection.find_all_by_drop_off_location_time_id_and_delivery_date_time(drop_off_location_time_id, date)
     @delivery_time_record = DropOffLocationTime.find(drop_off_location_time_id)
     @delivery_time = @delivery_time_record.delivery_time.strftime("%I:%M%p").downcase
     @drop_off_location = DropOffLocation.find(@delivery_time_record.drop_off_location_id)
     @quantity = order_quantity
     @vendor = Vendor.find(Menu.find(@location_selections[0].menu_id).vendor_id)
     mail(:to => user.email,
          :subject => "Your Bakery Market Order Summary")
   end
  
end
