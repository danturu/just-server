module EventObserver
  extend ActiveSupport::Concern

  included do
    after_save :notify
  end

  def notify
    Messages.publish EventSerializer.new(self)
  end
end
