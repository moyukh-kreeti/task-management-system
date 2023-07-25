# frozen_string_literal: true

# Subtask Model
class SubTask < ApplicationRecord
  belongs_to :task
end
