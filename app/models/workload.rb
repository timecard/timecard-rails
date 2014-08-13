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
    end_at_or_now - start_at
  end

  def formatted_duration(format = '%h:%m:%s')
    Time.diff(start_at, end_at_or_now, format)[:diff]
  end

  def self.total_duration
    duration = complete.inject(0) {|sum, w| sum += w.duration }
    hour = (duration / (60 * 60)).floor
    duration = duration - (hour * 60 * 60)
    min = (duration / 60).floor
    sec = duration - (min * 60)
    "#{sprintf('%02d', hour)}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
  end

  def formatted_distance_of_time
    "#{start_at.hour}:#{start_at.min}-#{end_at_or_now.hour}:#{end_at_or_now.min}"
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

  def end_at_or_now
    (end_at.presence || Time.zone.now)
  end
end
