require 'spec_helper'

describe Workload do
  describe "#daily" do
    it "returns workloads on the day" do
      today_workload = create(:workload, start_at: Time.now.utc, end_at: 1.hour.since(Time.now.utc))
      last_week_workload = create(:workload, start_at: 1.week.ago(Time.now.utc), end_at: 1.week.ago(1.hour.since(Time.now.utc)))
      expect(Workload.daily(Date.today)).to eq([today_workload])
    end
  end
end
