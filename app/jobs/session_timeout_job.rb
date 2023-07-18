require 'httparty'
class SessionTimeoutJob < ApplicationJob
  queue_as :default

  def perform(auth); end
end
