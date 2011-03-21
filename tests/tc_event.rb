require 'test/unit'
require 'dogapi'

class TestEventClient < Test::Unit::TestCase

  def config_client_test_env
    @api_key = Dogapi.find_api_key
    if !@api_key
      @api_key = 'apikey_2'
      ENV['DATADOG_KEY'] = @api_key
    end

    @host = Dogapi.find_datadog_host
    if !@host
      @host = 'localhost:5000'
      ENV['DATADOG_HOST'] = @host
    end
  end

  def setup
    config_client_test_env
  end

  def submit_event(scope=nil, source_type=nil)
    event_service = Dogapi::EventService.new(@host)
    tok = '#' + (rand(10000)+1).to_s
    test_message = 'event_test_' + tok
    event = Dogapi::Event.new(test_message, :event_type => 'test-event-type')
    res = event_service.submit(@api_key, event, scope, source_type)
    assert_not_equal(res['id'], nil)
  end

  def test_submit_event
    submit_event
  end

  def test_submit_scoped_event
    submit_event(Dogapi::Scope.new('scoped-testhost', 'testdevice'))
  end

  def test_submit_event
    submit_event(Dogapi::Scope.new('typed-testhost', 'testdevice'), 'Nagios')
    submit_event(Dogapi::Scope.new('typed-testhost', 'testdevice'), 'GitHub')
  end

end