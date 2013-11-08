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
      post STUDENT_EVENTS
      last_response.status.should == 200
    end


  end
end
