#### Frontend Rescue

frontend_rescue provides a backend endpoint as a rack middleware for your frontend JavaScript application to send errors to when they’re caught.

This makes it easier to integrate your frontend stack traces to your backend analytics.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'frontend_rescue'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install frontend_rescue

## Backend Usage

#### Rails

Use the frontend_rescue middleware :

    Rails.application.configure do
      config.middleware.use ClientErrorHandler::Middleware, paths: ['/frontend-error']
    end

#### Options

**status_code**

By default, frontend_rescue will respond with a ```500 (Server Error)```.

You can override this value with any HTTP status code you like :

    config.middleware.use ClientErrorHandler::Middleware, paths: ['/frontend-error'],
                                                          status_code: 200

**silent**

By default, frontend_rescue will output the frontend error to the logs.

You can pass in ```silent: true```, frontend errors are not logged. You will likely use this option when passing a block.

**&block**

You can pass in a block to frontend_rescue and it will be called and passed a FrontendRescue::Error and a Rack::Request :

    config.middleware.use ClientErrorHandler::Middleware, paths: ['/frontend-error'],
                                                          status_code: 200,
                                                          silent: true do |error, request|
      NewRelic::Agent.notice_error(error)
    end


#### Sinatra

    use ClientErrorHandler::Middleware, paths: ['/frontend-error']

With the options described above.

## Frontend Usage

Ideally you should catch all JavaScript errors and **post** them to your endpoint. Frontend frameworks like ember.js make this easy.

Ember example :

    Ember.onerror = function(error) {
      Ember.$.ajax('/frontend-error', {
        type: 'POST',
        data: {
          name: 'My App',
          user_agent: navigator.userAgent,
          message: error.message,
          stack: error.stack
        }
      });
    };


## Contributing

1. Fork it ( https://github.com/[my-github-username]/frontend_rescue/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

1. Tests...
