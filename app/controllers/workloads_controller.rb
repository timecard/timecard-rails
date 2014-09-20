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
    @issue = Issue.find(params[:issue_id])
    @workload = current_user.start_time_track(@issue)

    if Authentication.exists?(["provider = 'chatwork'"])
      rails_host = env["HTTP_HOST"]
      body = "#{current_user.name}さんが「#{@issue.project.name}」における「#{@issue.subject}」を開始しました\nhttp://#{rails_host}/issues/#{@issue.id}"
      Chatwork.post(body)
    end

    respond_to do |format|
      format.html { redirect_to @issue, notice: 'Work log was successfully started.' }
      format.json { render action: 'workload' }
    end
  rescue => e
    respond_to do |format|
      format.html { redirect_to :back, alert: e.message }
      format.json { render json: e.message, status: :unprocessable_entity }
    end
  end

  def update
    respond_to do |format|
      if @workload.update(workload_params)
        if current_user.crowdworks && @workload.issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
          logging_crowdworks
        end
        format.html { redirect_to @workload.issue, notice: 'Work log was successfully updated.' }
        format.json { render action: "workload" }
      else
        format.html { render action: 'edit' }
        format.json { render json: @workload.errors, status: :unprocessable_entity }
      end
    end
  rescue Crowdworks::Error::PasswordNotFound, Crowdworks::Error::LoginFailed => e
    respond_to do |format|
      format.html { redirect_to @workload.issue, alert: "Login failed to Crowdworks. Please check your username or password." }
      format.json { render json: @workload.errors, status: :unprocessable_entity }
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
    respond_to do |format|
      if @workload.update_attribute(:end_at, Time.now.utc)
        if current_user.crowdworks && @workload.issue.project.crowdworks_contracts.exists?(["user_id = ?", current_user.id])
          logging_crowdworks
        end
        format.html { redirect_to @workload.issue, notice: 'Work log was successfully stopped.' }
        format.json { render action: 'stop', status: :created, location: @workload }
        format.js
      end
    end
  rescue Crowdworks::Error::PasswordNotFound, Crowdworks::Error::LoginFailed => e
    respond_to do |format|
      format.html { redirect_to @workload.issue, alert: "Login failed to Crowdworks. Please check your username or password." }
      format.json { render json: @workload.errors, status: :unprocessable_entity }
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
    @crowdworks = Crowdworks.new
    @crowdworks.login(current_user.crowdworks.username, params[:password])
    @crowdworks.submit_timesheet(@workload)
  end
end
