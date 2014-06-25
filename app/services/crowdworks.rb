class Crowdworks
  LOGIN_URL = "https://crowdworks.jp/login"

  def initialize(username, password)
    raise unless password.present?
    @agent = Mechanize.new
    @agent.get(LOGIN_URL)
    @agent.page.form_with(method: "POST") do |form|
      form["username"] = username
      form["password"] = password
      form.click_button
    end
  end

  def submit_timesheet(contract_id, workload)
    @agent.get(timesheet_url(contract_id))
    @agent.page.form_with(method: "POST") do |form|
      form["fiscal_work[started_at(4i)]"] = workload.start_at.strftime("%H")
      form["fiscal_work[started_at(5i)]"] = workload.start_at.strftime("%M")
      form["fiscal_work[ended_at(4i)]"] = workload.end_at.strftime("%H")
      form["fiscal_work[ended_at(5i)]"] = workload.end_at.strftime("%M")
      form.click_button
    end
  end

  def timesheet_url(contract_id)
    today = Time.zone.today.strftime("%Y-%m-%d")
    timesheet_url = "https://crowdworks.jp/contracts/#{contract_id}/fiscal_works/new?date=#{today}"
  end
end
