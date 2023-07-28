# frozen_string_literal: true

# Task Model
class Task < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  validates :task_name, presence: true
  validates :task_category, presence: true
  validates :task_date, presence: true
  validates :task_time, presence: true
  validates :repeat_interval, presence: true
  validates :task_importance, presence: true
  validates :description, presence: true

  def self.index_data
    __elasticsearch__.create_index!
    __elasticsearch__.import force: true
  end

  settings do
    mappings dynamic: false do
      indexes :task_name, type: :text, analyzer: :english
      indexes :description, type: :text, analyzer: :english
      indexes :status, type: :integer
      indexes :user_id, type: :integer
    end
  end

  def as_indexed_json(_options = {})
    {
      task_name:,
      description:,
      status: Task.statuses[status],
      user_id:
    }
  end

  def self.search_tasks(query, status, id)
    wildcards_query = query.split.map { |term| "*#{term}*" }.join(' ')
    response = search({ query: {
                        bool: {
                          must: [{ query_string: { query: wildcards_query, fields: %w[task_name description] } },
                                 { match: { user_id: id } }],
                          filter: { terms: { status: [status] } }
                        }
                      } })
    response.records
  end

  index_data

  belongs_to :user, optional: true
  belongs_to :task_category, foreign_key: 'task_category_id'
  has_many :sub_tasks, dependent: :destroy
  has_many_attached :attachments

  enum task_importance: {
    Low: 0,
    Medium: 1,
    High: 2
  }

  def interval_of_notifications
    @interval_of_notification = {
      1 => 1.days,
      2 => 7.days,
      3 => 1.months,
      4 => 3.months,
      5 => 6.months,
      6 => 1.years
    }
  end
end
