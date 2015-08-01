class MessagesMiddleware
  KEEPALIVE_TIME = 15
  CHANNEL        = "just"

  def initialize(app)
    @app     = app
    @clients = []

    Thread.new do
      redis = Redis.new url: Redis.current.client.options[:url]

      redis.subscribe(CHANNEL) do |on|
        on.message do |channel, message|
          @clients.each { |ws| ws.send(message) }
        end
      end
    end

    EM.error_handler do |ex|
      Rails.logger.error [ex.inspect, ex.backtrace] if ex.backtrace.join() =~ /#{__FILE__}/i
    end
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME })

      ws.on :open do |event|
        @clients << ws
      end

      ws.on :message do |event|
        @redis.publish(CHANNEL, sanitize(event.data))
      end

      ws.on :close do |event|
        @clients.delete(ws)
        ws = nil
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end

private

  def sanitize(message)
    json = JSON.parse(message)

    json.each do |key, value|
      json[key] = ERB::Util.html_escape(value)
    end

    JSON.generate json
  end
end
