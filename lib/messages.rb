module Messages
  extend self

  def publish(params={})
    Redis.current.publish MessagesMiddleware::CHANNEL, params.to_json
  end

  def scheme
    if Rails.env.production?
      "wss://"
    else
      "ws://"
    end
  end
end
