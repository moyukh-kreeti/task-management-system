# frozen_string_literal: true

require 'httparty'
# User Model
class User < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  paginates_per 6

  settings do
    mappings dynamic: false do
      indexes :name, type: :text, analyzer: :english
      indexes :surname, type: :text, analyzer: :english
      indexes :email, type: :text, analyzer: :english
    end
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

  enum roles: {
    employee: 0,
    HRD: 1,
    Admin: 2
  }
  has_many :task
  has_one_attached :image
  has_many :notification, dependent: :destroy
end
