class StudentEventsController < ApplicationController
  def create
    user = params[:user_id]
    event_records = params['events'].values

    File.open(params['data'].tempfile.path, 'rb') do |data_file|
      for record in event_records
        course_name = record['course_name']
        exercise_name = record['exercise_name']

        event_type = record['event_type']
        metadata = record['metadata']
        happened_at = record['happened_at']
        system_nano_time = record['system_nano_time']

        data_file.pos = record['data_offset'].to_i
        data = data_file.read(record['data_length'].to_i)

        unless StudentEvent.supported_event_types.include?(event_type)
          raise "Invalid event type: '#{event_type}'"
        end

        check_json_syntax(metadata) if metadata

        event = StudentEvent.create!(
          :user_name => user,
          :course_name => course_name,
          :exercise_name => exercise_name,
          :event_type => event_type,
          :metadata_json => metadata,
          :data => data,
          :happened_at => happened_at,
          :system_nano_time => system_nano_time
        )
      end
    end

    respond_to do |format|
      format.json do
        render :json => {:status => 'ok'}
      end
    end
  end

private

  def check_json_syntax(string)
    ActiveSupport::JSON.decode(string)
    nil
  end



end
