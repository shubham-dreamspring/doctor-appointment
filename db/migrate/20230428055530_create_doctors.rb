class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.text :address
      t.string :image_url
      t.decimal :fees
      t.string :busy_slots, array:true , default:['07:30 1']
      t.time :start_time, default: '06:30'
      t.time :end_time, default: '10:30'

      t.timestamps
    end
  end
end
