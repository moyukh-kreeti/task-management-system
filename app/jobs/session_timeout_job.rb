# frozen_string_literal: true

require 'httparty'
# SessionTimeoutJob class
class SessionTimeoutJob < ApplicationJob
  queue_as :default

  def perform(auth); end
end
