class Order < ActiveRecord::Base
  belongs_to :service_plan
  belongs_to :user
  has_many   :transactions, :class_name => "OrderTransaction"

  attr_accessor :card_number, :card_verification

  validate :validate_card, :on => :create

  def purchase(plan_id)
    order_total = price_in_cents(plan_id)
    response = process_purchase(plan_id)
    transactions.create!(:action => "purchase", :amount => order_total, :response => response)
    response.success?
  end

  def process_purchase(plan_id)
    order_total = price_in_cents(plan_id)
    if express_token.blank?
      STANDARD_GATEWAY.purchase(order_total, credit_card, :ip => ip_address)
    else
      EXPRESS_GATEWAY.purchase(order_total, :ip => ip_address, :token => express_token, :payer_id => express_payer_id)
    end
  end

  def price_in_cents(plan_id)
    return (ServicePlan.find(plan_id).price * 100).round
  end

  def express_token=(token)
    write_attribute(:express_token, token)
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end

  private

  def validate_card
    if express_token.blank?
      if !credit_card.valid?
        credit_card.errors.full_messages.each do |message|
          errors.add_to_base message
        end
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
end
