class AddStateToAttendance < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :state, :string
  end
end
