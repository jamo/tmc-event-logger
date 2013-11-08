$stdout.reopen("#{File.dirname(File.realpath(__FILE__))}/log/rack.log")
$stderr.reopen($stdout)
$stdout.sync = true
$stderr.sync = true

WEBBAPP_ROOT = File.dirname(File.realpath(__FILE__))

$LOAD_PATH.unshift WEBBAPP_ROOT + '/lib'

require 'rack'
require 'rack/commonlogger'
require 'student_events_recorder_app'

log = File.new("log/access.log", "a+")

log.sync = true
use(Rack::CommonLogger, log)

run StudentEventsRecorderApp.new
