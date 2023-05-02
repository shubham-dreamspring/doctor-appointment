class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.text :address
      t.string :image_url
      t.decimal :fees
      t.string :busy_slots, array:true , default:['01:00 PM 1']
      t.time :start_time, default: '12:00 PM'
      t.time :end_time, default: '04:00 PM'

      t.timestamps
    end
  end
end
