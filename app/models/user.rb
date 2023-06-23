require 'httparty'
class User < ApplicationRecord
  enum roles:{
    employee: 0,
    HRD: 1,
    Admin: 2
  }
  has_many :task
  has_one_attached :image
end
