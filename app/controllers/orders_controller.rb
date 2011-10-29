class OrdersController < ApplicationController
  def express
    @order = Order.new(:user_id => current_user.id, :service_plan_id => params[:id])
    response = EXPRESS_GATEWAY.setup_purchase(@order.price_in_cents(params[:id]),
      :ip => request.remote_ip,
      :return_url => "#{new_order_url}/#{params[:id]}",
      :cancel_return_url => root_url
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

  def express_confirmation
    @title = "Bakery Market | Purchase Credits"
    @google_fonts = "Josefin+Slab|Dancing+Script|Lato"
    @stylesheet = "users"
    @service_plan = ServicePlan.find(params[:id])
    if params[:token]
      @order = Order.new(:express_token => params[:token])
    else
      redirect_to users_purchase_credits_path
    end
  end

  # GET /orders/new
  # GET /orders/new.xml
  def new
    @title = "Bakery Market | Purchase Credits"
    @google_fonts = "Josefin+Slab|Dancing+Script|Lato"
    @stylesheet = "users"
    if params[:id] < 4.to_s
      @service_plan = ServicePlan.find(params[:id])
    else
      @service_plan = ServicePlan.find(3)
    end
    @order = Order.new(:express_token => params[:token])
  end

  # POST /orders
  # POST /orders.xml
  def create
    @title = "Bakery Market | Purchase Credits"
    @google_fonts = "Josefin+Slab|Dancing+Script|Lato"
    @stylesheet = "users"
    @order = Order.new(params[:order])
    if params[:id] < 4.to_s
      @service_plan = ServicePlan.find(params[:id])
    else
      @service_plan = ServicePlan.find(3)
    end
    @order.service_plan_id = @service_plan.id
    @order.ip_address = request.remote_ip
    @order.user_id = current_user.id
    if @order.save
      if @order.purchase(@service_plan.id)
        @meals_remaining = current_user.meals_remaining + @service_plan.meals_included
        @total_credits_purchased = current_user.total_credits_purchased + @service_plan.meals_included
        current_user.update_attributes(:meals_remaining => @meals_remaining, :total_credits_purchased => @total_credits_purchased)
        flash[:notice] = "Thanks for your order. You're all set."
        redirect_to root_url
        UserMailer.purchase_complete(current_user, @service_plan).deliver
      else
        render :action => "failure"
      end
    else
      render :action => "new"
    end
  end
  
end
