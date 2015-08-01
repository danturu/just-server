if ENV.has_key? "REDISTOGO_URL"
  Redis.current = Redis.new url: ENV["REDISTOGO_URL"]
else
  Redis.current = Redis.new
end
