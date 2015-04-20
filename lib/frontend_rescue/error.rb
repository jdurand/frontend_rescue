module FrontendRescue
  class Error < StandardError
    def initialize(name, user_agent, message, trace, params)
      @trace = trace.split("\n") rescue []
      @user_agent = user_agent
      @params = params || {}
      super "Uncaught #{name} Error: #{message}"
    end

    def backtrace
      ["User Agent: #{user_agent}"] +
      @params.map{|k, v| "#{k}: #{v}"} +
      @trace
    end

    def user_agent
      @user_agent
    end
  end
end