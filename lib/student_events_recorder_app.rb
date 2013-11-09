require 'fileutils'
require 'multi_json'
require 'net/http'
require 'uri'
require 'app_log'
require 'pry'
#require 'bson_ex' may offer faster json parsing
class StudentEventsRecorderApp
  WEBAPP_ROOT = File.dirname(File.realpath(__FILE__) + "/..")
  EVENT_STORE_PATH = File.join(WEBAPP_ROOT, "events")

  def initialize
  end


  def call(env)
    raw_response = nil
    @req = Rack::Request.new(env)
    @resp = Rack::Response.new
    if @req.path.end_with?('.html')
      @resp['Content-Type'] = 'text/html; charset=utf-8'
      @respdata = ''
      @request_type = :html
    else
      @resp['Content-Type'] = 'application/json; charset=utf-8'
      @respdata = {}
      @request_type = :json
    end

    serve_request

    raw_response = @resp.finish do
      if @req.path.end_with?('.json')
        @resp.write(MultiJson.encode(@respdata))
      else
        @resp.write(@respdata)
      end
    end
    raw_response
  end


  private
  def serve_request
    begin
      if @req.post? && @req.path == '/student_events.json'
        serve_post_task
      elsif @req.get? && @req.path == '/status.json'
        serve_status
        #elsif @plugin_manager.serve_request(@req, @resp, @respdata)
        # ok
      else
        @resp.status = 404
        case @request_type
        when :json
          @respdata[:status] = 'not_found'
        when :html
          @respdata << "<html><body>Not found</body></html>"
        end
      end
    rescue BadRequest
      @resp.status = 500
      case @request_type
      when :json
        @respdata[:status] = 'bad_request'
      when :html
        @respdata << "<html><body>Bad request</body></html>"
      end
    rescue
      AppLog.warn("Error processing request:\n#{AppLog.fmt_exception($!)}")
      @resp.status = 500
      case @request_type
      when :json
        @respdata[:status] = 'error'
      when :html
        @respdata << "<html><body>Error</body></html>"
      end
    end
  end

  def serve_status
    @respdata[:loadavg] = File.read("/proc/loadavg").split(' ')[0..2] if File.exist?("/proc/loadavg")
  end

  def serve_post_task
    if @req.params['events']
      handle_events
      # it shoud do somethig with events json :D
      @respdata[:status] = 'ok'
    else
      @resp.status = 500
      @respdata[:status] = 'busy'
    end
  end

  def handle_events
    params = @req.params
    user = "auth_user"

      binding.pry
    event_records = params['events'].values

    File.open(params['data'].tempfile.path, 'rb') do |data_file|
      event_records.each do |record|
        course_name = record['course_name']
        exercise_name = record['exercise_name']

        event_type = record['event_type']
        metadata = record['metadata']
        happened_at = record['happened_at']
        system_nano_time = record['system_nano_time']

        data_file.pos = record['data_offset'].to_i
        data = data_file.read(record['data_length'].to_i)

        # Not sure if we want to validate this - but lets leave this commented anyway :D
        #unless StudentEvent.supported_event_types.include?(event_type)
        #  raise "Invalid event type: '#{event_type}'"
        #end

        # no walidations!
        # check_json_syntax(metadata) if metadata

        json = {
          :user => user,
          :course_name => course_name,
          :exercise_name => exercise_name,
          :event_type => event_type,
          :metadata_json => metadata,
          :data => data,
          :happened_at => happened_at,
          :system_nano_time => system_nano_time
        }
        write_json_to_file(json)
      end
    end
  end

  def write_json_to_file(json)
    course = json[:course_name]
    exercise = json[:exercise_name]
    user = json[:user]
    happend_at = json[happened_at]
    path = File.join(EVENT_STORE_PATH, course, exercise)

    FileUtils.mkdir_p(path) unless File.exist?(user_dir)
    filename = "wtf"
    File.new(File.join(path, filename)) do |f|
      f.write(json.to_json)
    end

    #case ev.event_type
    #when 'code_snapshot'
    #  write_file("#{user_dir}/#{record_name}.zip", ev.data)
    #else
    #  json[:data] = ev.data
    #end

  end



  def check_json_syntax(string)
    ActiveSupport::JSON.decode(string)
    nil
  end

end



class BadRequest < StandardError; end

