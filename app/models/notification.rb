# frozen_string_literal: true

# Notification Model
class Notification < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
end
