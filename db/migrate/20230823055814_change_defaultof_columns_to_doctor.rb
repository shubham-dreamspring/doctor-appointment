class ChangeDefaultofColumnsToDoctor < ActiveRecord::Migration[7.0]
  def change
    change_column_default :doctors, :start_time, from: '06:30', to: '04:30'
  end
end
