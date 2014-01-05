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

  def update
    respond_to do |format|
      if @workload.update(workload_params)
        format.html { redirect_to @workload.issue, notice: 'Work log was successfully updated.' }
        format.json { head :no_content }
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

  def start
    if current_user.workloads.running?
      @prev_issue = current_user.working_issue
      current_user.running_workload.update!(end_at: Time.now.utc)
    end
    @issue = Issue.find(params[:issue_id])
    @workload = @issue.workloads.build(start_at: Time.now.utc, user_id: current_user.id)

    if @workload.save
      base_url = 'https://api.chatwork.com/v1'
      room_id = 24680
      url = "/rooms/#{room_id}/messages"
      token = Authentication.get_chatwork_token
      rails_host = env["HTTP_HOST"]
      body = "#{current_user.name}さんが「#{@issue.project.name}」における「#{@issue.subject}」を開始しました\nhttp://#{rails_host}/issues/#{@issue.id}"
      `curl -X POST -H "X-ChatWorkToken: #{token}" -d "body=#{body}" "#{base_url}#{url}"`

      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Work log was successfully started.' }
        format.js
        format.json { render action: 'start', status: :created, location: @workload }
      end
    end
  end

  def stop
    if @workload.update_attribute(:end_at, Time.now.utc)
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
    params.require(:workload).permit(:start_at, :end_at, :issue_id, :user_id)
  end
end
