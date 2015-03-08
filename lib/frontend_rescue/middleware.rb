require 'rack'

module FrontendRescue
  class Middleware
    def initialize(app, opts={}, &block)
      @app = app
      @opts = default_options.merge(opts)
      @block = block
    end

    def call(env)
      if frontend_error?(env)
        handle_error Rack::Request.new(env)
      else
        @app.call(env)
      end
    end

    private
      def handle_error(request)
        error = FrontendRescue::Error.new request.params['name'],
                                          request.params['user_agent'],
                                          request.params['message'],
                                          request.params['stack']

        request.env['rack.errors'].puts "Processing #{error.class}" unless silent?

        if @block
          @block.call(error, request)
        end

        unless silent?
          request.env['rack.errors'].puts error.message
          request.env['rack.errors'].puts error.backtrace.join("\n")
          request.env['rack.errors'].flush
        end

        request.env['rack.errors'].puts "Completed #{status_code} OK" unless silent?
        [status_code, {}, []]
      end

      def default_options
        {
          paths: ['/frontend-error'],
          silent: false,
          status_code: 500
        }
      end

      def frontend_error?(env)
        env['REQUEST_METHOD'] == 'POST' &&
        @opts[:paths].include?(env['PATH_INFO'])
      end

      def silent?
        @opts[:silent]
      end

      def status_code
        @opts[:status_code]
      end

  end
end