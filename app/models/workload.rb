class Workload < ActiveRecord::Base
  scope :complete, -> { where("end_at is not ?", nil) }
  scope :uncomplete, -> { where("end_at IS NULL") }
  scope :daily, -> (date) { 
    where("start_at >= ? AND start_at < ?", date.beginning_of_day, date.end_of_day) 
  }

  belongs_to :issue
  belongs_to :user

  validates :start_at, presence: true

  def self.running?
    exists?(["start_at is not ? and end_at is ?", nil, nil])
  end
end
