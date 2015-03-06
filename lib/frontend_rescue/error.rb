module FrontendRescue
  class Error < StandardError
    def initialize(name, user_agent, message, trace)
      @trace = trace.split("\n") if trace.is_a? String
      @user_agent = user_agent
      super "Uncaught #{name} Error: #{message}"
    end

    def backtrace
      ["User Agent: #{user_agent}"] + @trace
    end

    def user_agent
      @user_agent
    end
  end
end