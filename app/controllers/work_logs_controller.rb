class WorkLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work_log, only: [:edit, :update, :destroy, :stop]

  # GET /work_logs/1/edit
  def edit
  end

  # PATCH/PUT /work_logs/1
  # PATCH/PUT /work_logs/1.json
  def update
    respond_to do |format|
      if @work_log.update(work_log_params)
        format.html { redirect_to @work_log.issue, notice: 'Work log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @work_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_logs/1
  # DELETE /work_logs/1.json
  def destroy
    @work_log.destroy
    respond_to do |format|
      format.html { redirect_to @work_log.issue }
      format.json { head :no_content }
    end
  end

  def start
    if current_user.work_logs.running?
      current_user.work_logs.running.update_attribute(:end_at, Time.now.utc)
    end
    @issue = Issue.find(params[:issue_id])
    @work_log = @issue.work_logs.build(start_at: Time.now.utc, user_id: current_user.id)

    if @work_log.save
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Work log was successfully started.' }
        format.json { render action: 'show', status: :created, location: @work_log }
      end
    end
  end

  def stop
    if @work_log.update_attribute(:end_at, Time.now.utc)
      respond_to do |format|
        format.html { redirect_to @work_log.issue, notice: 'Work log was successfully stopped.' }
        format.json { render action: 'show', status: :created, location: @work_log }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_log
      @work_log = WorkLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_log_params
      params.require(:work_log).permit(:start_at, :end_at, :issue_id, :user_id)
    end
end
