class WorkloadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_workload, only: [:edit, :update, :destroy, :stop]
  authorize_resource

  def index
    if params[:user_id].present?
      if params[:day].present?
        date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
        @workloads = current_user.workloads.daily(date).complete
      else
        @workloads = current_user.workloads.complete
      end
    end

    respond_to do |format|
      format.json
    end
  end

  def edit
  end

  def create
    if current_user.workloads.running?
      @prev_issue = current_user.working_issue
      current_user.running_workload.update!(end_at: Time.now.utc)
    end
    @issue = Issue.find(params[:issue_id])
    @workload = @issue.workloads.build(start_at: Time.now.utc, user_id: current_user.id)

    if @workload.save
      if Authentication.exists?(["provider = 'chatwork'"])
        rails_host = env["HTTP_HOST"]
        body = "#{current_user.name}さんが「#{@issue.project.name}」における「#{@issue.subject}」を開始しました\nhttp://#{rails_host}/issues/#{@issue.id}"
        Chatwork.post(body)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Work log was successfully started.' }
        format.js
        format.json { render action: 'workload' }
      end
    end
  end

  def update
    respond_to do |format|
      if @workload.update(workload_params)
        if current_user.authentications.exists?(["provider = ?", "crowdworks"]) && @workload.issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
          logging_crowdworks
        end
        format.html { redirect_to @workload.issue, notice: 'Work log was successfully updated.' }
        format.json { render action: "workload" }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workload.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @workload.destroy
    respond_to do |format|
      format.html { redirect_to @workload.issue }
      format.json { head :no_content }
    end
  end

  def stop
    if @workload.update_attribute(:end_at, Time.now.utc)
      if current_user.authentications.exists?(["provider = ?", "crowdworks"]) && @workload.issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
        logging_crowdworks
      end
      respond_to do |format|
        format.html { redirect_to @workload.issue, notice: 'Work log was successfully stopped.' }
        format.js
        format.json { render action: 'stop', status: :created, location: @workload }
      end
    end
  end

  private

  def set_workload
    @workload = Workload.find(params[:id])
  end

  def workload_params
    params.require(:workload).permit(:id, :start_at, :end_at, :issue_id, :user_id, :created_at, :updated_at, :password)
  end
  
  def logging_crowdworks
    # crowdworks target uri
    # https://crowdworks.jp/contracts/77127/fiscal_works/new?date=2014-01-08
    # etc.
    begin
      project = @workload.issue.project
      contract_id = project.crowdworks_contracts.find_by(user: current_user).contract_id
      crowdworks = current_user.authentications.where(provider: "crowdworks").first

      crowdworks_login_url = "https://crowdworks.jp/login"
      crowdworks_id = crowdworks.username
      crowdworks_password = params[:password]

      today = Date.today.strftime("%Y-%m-%d")
      crowdworks_timesheet_url = "https://crowdworks.jp/contracts/#{contract_id}/fiscal_works/new?date=#{today}"

      if crowdworks_password.present?
        agent = Mechanize.new
        agent.get(crowdworks_login_url)
        agent.page.form_with(:method => "POST"){|form|
          form["username"] = crowdworks_id
          form["password"] = crowdworks_password
          form.click_button
        }
        agent.get(crowdworks_timesheet_url)
        agent.page.form_with(:method => "POST"){|form|
          form["fiscal_work[started_at(4i)]"] = @workload.start_at.strftime("%H")
          form["fiscal_work[started_at(5i)]"] = @workload.start_at.strftime("%M")
          form["fiscal_work[ended_at(4i)]"] = @workload.end_at.strftime("%H")
          form["fiscal_work[ended_at(5i)]"] = @workload.end_at.strftime("%M")
          form.click_button
        }
      end
    rescue => e
      logger.debug "#{e.class}: #{e.message}"
    end
  end
end
