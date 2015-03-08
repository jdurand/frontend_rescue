require_relative '../../test_helper'

describe FrontendRescue::Middleware do
  let(:app) { MockRackApplication.new({'CONTENT_TYPE' => content_type, 'HTTP_USER_AGENT' => user_agent}) }
  let(:middleware) { FrontendRescue::Middleware.new(app) }
  let(:request) { Rack::MockRequest.new(middleware) }
  let(:response) { request.post(request_path, input: post_data) }

  let(:request_path) { "/some/path" }
  let(:post_data) { "String or IO post data" }
  let(:content_type) { "text/plain" }
  let(:user_agent) { "Mozilla/5.0 (iPad; CPU OS 8_1_3 like Mac OS X)..." }

  describe "when called with a POST request" do
    describe "with any data" do
      it "passes the request through unchanged" do
        response['Content-Type'].must_equal 'text/plain'
        response['Content-Length'].to_i.must_equal post_data.length
        response.body.must_equal post_data
      end
    end
  end

  describe "when called with a GET request to a given endpoint" do
    let(:request_path) { "/frontend-error" }
    let(:response) { request.get(request_path, input: post_data, 'CONTENT_TYPE' => 'text/plain') }

    it "should not handle the request" do
      response.body.wont_be_empty
    end
    it "should return HTTP status 200" do
      response.status.must_equal 200
    end
  end

  describe "when called with a POST request to a given endpoint" do
    let(:request_path) { "/frontend-error" }

    describe "with any data" do
      it "should handle the request" do
        response.body.must_be_empty
      end
      it "should return HTTP status 500" do
        response.status.must_equal 500
      end
    end

    describe "when a custom endpoint and HTTP code are passed" do
      let(:middleware) { FrontendRescue::Middleware.new(app, status_code: 200, paths: ["/my/custom/path"]) }
      let(:request_path) { "/my/custom/path" }
      it "should handle the request" do
        response.body.must_be_empty
      end
      it "should return HTTP status 200" do
        response.status.must_equal 200
      end
    end

    describe "when silent option is passed" do
      let(:middleware) { FrontendRescue::Middleware.new(app, silent: true) }
      it "should not log to std out" do
        response.errors.must_be_empty
      end
    end

    describe "when a block is passed" do
      let(:middleware) { FrontendRescue::Middleware.new(app) {|e,r| r.env['rack.errors'].puts 'The answer is 42' }}
      it "should be executed" do
        response.errors.must_match /The\sanswer\sis\s42/
      end
    end

    describe "when exclude_user_agent is passed" do
      let(:middleware) { FrontendRescue::Middleware.new(app, exclude_user_agent: /Googlebot/) }
      let(:user_agent) { 'Googlebot/2.1; +http://www.google.com/bot.html...' }
      it "should ignore matching user agent" do
        skip("I don't know how to test this")
        response.status.must_equal 404
      end
    end
  end
end