module FrontendRescue
  class Middleware
    def initialize(app, opts, &block)
      @app = app
      @opts = opts
      @block = block
    end

    def call(env)
      if env['REQUEST_METHOD'] == 'POST' && @opts[:paths].include?(env['PATH_INFO'])
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

        request.env['rack.errors'].puts "Processing #{error.class}" unless @opts[:silent]

        if @block
          @block.call(error, request)
        end

        unless @opts[:silent]
          request.env['rack.errors'].puts error.message
          request.env['rack.errors'].puts error.backtrace.join("\n")
          request.env['rack.errors'].flush
        end

        code = @opts[:status_code] || 500
        request.env['rack.errors'].puts "Completed #{code} OK"
        [code, {}, []]
      end

  end
end