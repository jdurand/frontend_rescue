class MockRackApplication
  def initialize(headers={})
    @request_headers = default_request_headers.merge(headers)
  end

  def call(env)
    @env = env = env.merge(@request_headers)
    request_body = env['rack.input'].read
    [200, {'Content-Type' => 'text/plain'}, [request_body]]
  end

  def [](key)
    @env[key]
  end

  private
    def default_request_headers
      {
        'CONTENT_TYPE' => 'text/plain',
        'HTTP_USER_AGENT' => 'Mozilla/5.0 (iPad; CPU OS 8_1_3 like Mac OS X)...'
      }
    end

end