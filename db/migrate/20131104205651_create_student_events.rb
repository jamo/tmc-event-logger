class CreateStudentEvents < ActiveRecord::Migration
  def change
    create_table :student_events do |t|
      t.string :user_name
      t.string :course_name
      t.string :exercise_name
      t.string :event_type
      t.string :metadata_json, null: true
      t.binary :data
      t.datetime :happened_at
      t.integer :system_nano_time

      t.timestamps
    end
  end
end
