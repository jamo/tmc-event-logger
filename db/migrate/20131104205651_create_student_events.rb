class CreateStudentEvents < ActiveRecord::Migration
  def change
    create_table :student_events do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :exercise_name
      t.string :event_type
      t.binary :data
      t.datetime :happened_at
      t.integer :system_nano_time

      t.timestamps
    end
  end
end
