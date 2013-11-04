class StudentEvent < ActiveRecord::Base

  def self.supported_event_types
    ['code_snapshot', 'project_action', 'text_insert', 'text_remove', 'text_paste']
  end

end
