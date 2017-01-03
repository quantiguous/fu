class CreateScServices < ActiveRecord::Migration
  def up
    create_table :sc_services, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.string "code", :limit=>50, :null=>false, :comment => 'the code for the service'
      t.string "name", :limit=>50, :null=>false, :comment => 'the code for the service'
    end

    add_index :sc_services, :code, :unique => true, :name => 'in_sc_services_1'
    add_index :sc_services, :name, :unique => true, :name => 'in_sc_services_2'
  end
end
