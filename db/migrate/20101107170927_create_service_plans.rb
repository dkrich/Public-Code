class CreateServicePlans < ActiveRecord::Migration
  def self.up
    create_table :service_plans do |t|
      t.string :name
      t.string :service_name_proper
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :meals_included
      t.timestamps
    end
  end

  def self.down
    drop_table :service_plans
  end
end
