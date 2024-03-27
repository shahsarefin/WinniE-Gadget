class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.integer :province_id
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
