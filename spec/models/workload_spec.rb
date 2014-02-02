require 'spec_helper'

describe Workload do
  describe "#daily" do
    before :all do
      @time = Time.zone.local(2014, 02, 01, 21, 0, 0)
    end

    it "returns workloads on the day" do
      today_workload = create(:workload, start_at: @time, end_at: 1.hour.since(@time))
      last_week_workload = create(:workload, start_at: 1.week.ago(@time), end_at: 1.week.ago(1.hour.since(@time)))
      expect(Workload.daily(@time.to_date)).to eq([today_workload])
    end
  end
end
