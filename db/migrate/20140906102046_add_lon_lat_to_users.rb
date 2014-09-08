class AddLonLatToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lat, :float
    add_column :users, :lon, :float
    add_index :users, [:lat, :lon]
  end
end
