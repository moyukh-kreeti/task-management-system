# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John' }
    surname { 'Doe' }
    sequence(:email) { |n| "john.doe#{n}@example.com" }
    roles { User.roles.keys.sample }
    sequence(:employee_id) { |n| n.to_s.rjust(6, '0') }
    image { nil }
  end
end
