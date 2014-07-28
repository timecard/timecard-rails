class Workload < ActiveRecord::Base
  include PublicActivity::Model

  scope :complete, -> { where("end_at is not ?", nil) }
  scope :uncomplete, -> { where("end_at IS NULL") }
  scope :daily, ->(date = Time.zone.today) do
    where("start_at >= ? AND start_at < ?", date.beginning_of_day, date.end_of_day) 
  end
  scope :weekly, ->(date = Time.zone.today) do
    where("start_at >= ? AND start_at < ?", date.beginning_of_week, date.end_of_week)
  end

  belongs_to :issue
  belongs_to :user

  validates :start_at, presence: true

  after_create :track_start_activity
  before_update :track_stop_activity

  def self.running?
    exists?(["start_at is not ? and end_at is ?", nil, nil])
  end

  def duration
    return "" if self.end_at.nil?
    duration = self.end_at - self.start_at
    hour = (duration / (60 * 60)).floor
    duration = duration - (hour * 60 * 60)
    min = (duration / 60).floor
    sec = duration - (min * 60)
    "#{sprintf('%02d', hour)}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
  end

  def self.total_duration
    duration = complete.inject(0) {|sum, w| sum = w.end_at - w.start_at }
    hour = (duration / (60 * 60)).floor
    duration = duration - (hour * 60 * 60)
    min = (duration / 60).floor
    sec = duration - (min * 60)
    "#{sprintf('%02d', hour)}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
  end

  private

  def track_start_activity
    self.create_activity(:start, owner: self.user, recipient: self.issue.project)
  end

  def track_stop_activity
    if self.changes.has_key?("end_at") && self.changes["end_at"][0] == nil
      self.create_activity(:stop, owner: self.user, recipient: self.issue.project)
    end
  end
end
