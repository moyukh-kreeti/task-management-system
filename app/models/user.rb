# frozen_string_literal: true

require 'httparty'
# User Model
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }
  validates :roles, presence: true, numericality: { only_integer: true }
  validates :surname, presence: true
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do
    mappings dynamic: false do
      indexes :name, type: :text, analyzer: :english
      indexes :surname, type: :text, analyzer: :english
      indexes :email, type: :text, analyzer: :english
    end
  end

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import force: true
  end

  def as_indexed_json(_options = {})
    {
      name:,
      surname:,
      email:
    }
  end

  def self.search_user(query)
    wildcards_query = query.split.map { |term| "*#{term}*" }.join(' ')
    response = search({ query: {
                        bool: {
                          must: [{ query_string: { query: wildcards_query, fields: %w[name surname email] } }]
                        }
                      } })
    response.records
  end

  index_data

  enum roles: {
    employee: 0,
    HRD: 1,
    Admin: 2
  }
  has_many :task, dependent: :destroy
  has_one_attached :image
  has_many :notification, dependent: :destroy
end
