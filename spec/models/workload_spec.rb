require 'rails_helper'

describe Workload do
  before do
    Time.zone = 'UTC'
    Timecop.freeze(Time.zone.local(2014, 01, 01, 0, 0))
  end

  after do
    Timecop.return
  end

  describe "#daily" do
    it "returns workloads on the day" do
      today_workload = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      last_week_workload = create(:workload, start_at: 1.week.ago(Time.zone.now), end_at: 1.week.ago(1.hour.since(Time.zone.now)))
      expect(Workload.daily(Time.zone.now)).to eq([today_workload])
      expect(Workload.daily(1.week.ago(Time.zone.now))).to eq([last_week_workload])
    end
  end

  describe "#weekly" do
    it "returns worklaods of that week" do
      workload1 = create(:workload, start_at: Time.zone.now.beginning_of_week, end_at: 1.hour.since(Time.zone.now.beginning_of_week))
      workload2 = create(:workload, start_at: Time.zone.now.end_of_week, end_at: 1.hour.since(Time.zone.now.end_of_week))
      expect(Workload.weekly(Time.zone.now)).to eq([workload1, workload2])
    end
  end

  describe ".running" do
    it "returns true if time entry is started" do
      create(:workload, start_at: Time.zone.now, end_at: nil)
      expect(Workload.running?).to eq(true)
    end

    it "returns false if time entry is not started" do
      create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      expect(Workload.running?).to eq(false)
    end
  end

  describe "#duration" do
    it "returns number of duration" do
      workload = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      expect(workload.duration).to eq(3600)
    end
  end

  describe ".total_duration" do
    it "returns number of total duration" do
      workload1 = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      workload2 = create(:workload, start_at: Time.zone.now, end_at: 30.minutes.since(Time.zone.now))
      expect(Workload.total_duration).to eq(workload1.duration + workload2.duration)
    end
  end

  describe ".formatted_total_duration" do
    it "returns text of formatting total duration" do
      workload1 = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      workload2 = create(:workload, start_at: Time.zone.now, end_at: 30.minutes.since(Time.zone.now))
      expect(Workload.formatted_total_duration).to eq("01:30:00")
    end
  end

  describe "#formatted_duration" do
    it "returns text of formatting duration" do
      workload = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      expect(workload.formatted_duration).to eq("01:00:00")
    end
  end

  describe "#formatted_distance_of_time" do
    it "returns text of formatting distance" do
      workload = create(:workload, start_at: Time.zone.now, end_at: 1.hour.since(Time.zone.now))
      expect(workload.formatted_distance_of_time).to eq("00:00-01:00")
    end
  end

  describe "#stop" do
    it "updates end_at by time of now" do
      workload = create(:workload, start_at: Time.zone.now, end_at: nil)
      workload.stop
      expect(workload.end_at).not_to be_nil
    end
  end
end
