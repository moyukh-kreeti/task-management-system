# frozen_string_literal: true

# TaskCategory Model
class TaskCategory < ApplicationRecord
  has_many :tasks, dependent: :destroy
end
