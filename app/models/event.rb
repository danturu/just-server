class Event
  include Mongoid::Document
  include Mongoid::Timestamps
  include EventObserver
end
