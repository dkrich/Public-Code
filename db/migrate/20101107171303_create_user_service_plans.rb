class CreateUserServicePlans < ActiveRecord::Migration
  def self.up
    create_table :user_service_plans do |t|
      t.integer :user_id
      t.integer :service_plan_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :user_service_plans
  end
end
