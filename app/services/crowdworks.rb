module Crowdworks
  module Error
    class PasswordNotFound < StandardError; end
    class LoginFailed < StandardError; end
  end

  class << self
    def new
      Client.new
    end
  end

  class Client
    LOGIN_URL = "https://crowdworks.jp/login"

    attr_reader :agent

    def initialize
      @agent = Mechanize.new
    end

    def login(username, password)
      @agent.get(LOGIN_URL)
      raise Crowdworks::Error::PasswordNotFound if password.blank?
      @agent.page.form_with(method: "POST") do |form|
        form["username"] = username
        form["password"] = password
        form.click_button
      end
      if @agent.page.uri.to_s =~ /#{LOGIN_URL}/
        raise Crowdworks::Error::LoginFailed
      else
        @agent
      end
    end

    def submit_timesheet(workload)
      contract_id = workload.issue.project.crowdworks_contracts.find_by(user: workload.user).contract_id
      open_edit_timesheet(contract_id)
      if workload.start_at.day == workload.end_at.day
        submit(
          s_hh: workload.start_at.hour,
          s_mm: workload.start_at.min,
          e_hh: workload.end_at.hour,
          e_mm: workload.end_at.min
        )
      else
        submit(
          s_hh: workload.start_at.hour,
          s_mm: workload.start_at.min
        )
        open_edit_timesheet(contract_id, workload.end_at)
        submit(
          e_hh: workload.end_at.hour,
          e_mm: workload.end_at.min
        )
      end
      nil
    end

    def submit(s_hh: "00", s_mm: "00", e_hh: "23", e_mm: "59")
      @agent.page.form_with(method: "POST") do |form|
        form["fiscal_work[started_at(4i)]"] = s_hh
        form["fiscal_work[started_at(5i)]"] = s_mm
        form["fiscal_work[ended_at(4i)]"] = e_hh
        form["fiscal_work[ended_at(5i)]"] = e_mm
        form.click_button
      end
    end

    def open_edit_timesheet(contract_id, date=Time.zone.today)
      formatted_date = date.strftime("%Y-%m-%d")
      @agent.get(timesheet_url(contract_id, formatted_date))
    end

    def timesheet_url(contract_id, date)
      "https://crowdworks.jp/contracts/#{contract_id}/fiscal_works/new?date=#{date}"
    end
  end
end
