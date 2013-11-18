require 'spec_helper'

describe Issue do
  describe "#do_today?" do
    describe "if will_start_at is nil" do
      it "should be return true" do
        issue = create(:issue, will_start_at: nil)
        expect(issue).to be_do_today
      end
    end

    describe "if will_start_at is earlier than now" do
      it "should be return true" do
        issue = create(:issue, will_start_at: Time.now)
        expect(issue).to be_do_today
      end
    end

    describe "if will_start_at is later than now" do
      it "should be return false" do
        issue = create(:issue, will_start_at: 1.day.since(Time.now))
        expect(issue).not_to be_do_today
      end
    end
  end
end
