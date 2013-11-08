require 'spec_helper'

describe "StudentEventRecorderApp" do
  STUDENT_EVENTS_PATH = "/student_events"
  STUDENT_EVENTS = "/student_events.json"
  def app
    @app || make_new_app
  end

  def make_new_app
    StudentEventsRecorderApp.new
  end


  it 'responds to get with 404' do
    get '/'
    last_response.status.should == 404
    last_request.request_method.should ==  "GET"
  end

  describe 'post /student_events.json' do
    it 'responds to post /student_events.json' do

      post_params =<<EOF
      {"events":{"426":{"data_length":"126", "event_type":"text_insert", "data_offset":"56931", "exercise_name":"week1-015.AgeOfMajority", "course_name":"2013-OOProgrammingWithJava-PART1", "happened_at":"2013-11-03 18:27:06.752", "system_nano_time":"1383496026752988000"}, "279":{"system_nano_time":"1383497241846504000", "event_type":"text_insert", "exercise_name":"week1-017.GreaterNumber", "happened_at":"2013-11-03 18:47:21.846", "data_offset":"34928", "data_length":"136", "course_name":"2013-OOProgrammingWithJava-PART1"}}, "data":"TODO-some-binary-data" , "api_version":"5", "client":"netbeans_plugin", "client_version":"0.4.1"}
EOF
      params = MultiJson.decode post_params

      post STUDENT_EVENTS, params
      last_response.status.should == 200
    end

    it 'should do something post /student_events.json with okish params' do
      #auth not yet implemented
      post_params =<<EOF
      {"events":{"426":{"data_length":"126", "event_type":"text_insert", "data_offset":"56931", "exercise_name":"week1-015.AgeOfMajority", "course_name":"2013-OOProgrammingWithJava-PART1", "happened_at":"2013-11-03 18:27:06.752", "system_nano_time":"1383496026752988000"}, "279":{"system_nano_time":"1383497241846504000", "event_type":"text_insert", "exercise_name":"week1-017.GreaterNumber", "happened_at":"2013-11-03 18:47:21.846", "data_offset":"34928", "data_length":"136", "course_name":"2013-OOProgrammingWithJava-PART1"}}, "data":"TODO-some-binary-data" , "api_version":"5", "client":"netbeans_plugin", "client_version":"0.4.1"}
EOF
      params = MultiJson.decode post_params

      post STUDENT_EVENTS, params
      pending
      last_response.status.should == 200
    end


  end
end
