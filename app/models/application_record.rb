class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  enum status:{
  Assigned: 0,
  Working: 1,
  Completed: 2
  }
end
