class IssuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:new, :create]
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :close, :reopen, :postpone, :do_today]
  before_action :reject_archived
  before_action :require_member, except: [:show]

  # GET /issues/1
  # GET /issues/1.json
  def show
    @title = @issue.subject
  end

  # GET /issues/new
  def new
    @issue = @project.issues.build
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  # POST /issues.json
  def create
    @issue = @project.issues.build(issue_params)
    respond_to do |format|
      if @issue.save

        if @issue.project.github && current_user.github
          issue = @issue.project.github.add_issue(current_user.github.oauth_token , params[:issue])
          if issue
            @issue.add_github(issue.number)
          else
            flash[:alert] = 'Create a new issue to Github failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'new' }
          end
        end

        if @issue.project.ruffnote && current_user.ruffnote
          issue = @issue.project.ruffnote.add_issue(current_user.ruffnote.oauth_token , params[:issue])
          if issue
            number = JSON.parse(issue.response.env[:body])["index"]
            @issue.add_ruffnote(number)
          else
            flash[:alert] = 'Create a new issue to Ruffnote failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'new' }
          end
        end

        format.html { redirect_to @issue, notice: 'Issue was successfully created.' }
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    respond_to do |format|
      if @issue.update(issue_params)
        if @issue.project.github
          issue = @issue.github.modify(
            current_user.github.oauth_token, issue_params
          )
          unless issue
            flash[:alert] = 'Update a new issue to Github failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'edit' }
          end
        end
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT projects/1/issues/1/close
  # PATCH/PUT projects/1/issues/1/close.json
  def close
    if @issue.update_attributes({ status: 9, closed_on: Time.now.utc })
      if @issue.github
        @issue.github.close(current_user.github.oauth_token)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  # PATCH/PUT projects/1/issues/1/reopen
  # PATCH/PUT projects/1/issues/1/reopen.json
  def reopen
    if @issue.update_attribute(:status, 1)
      respond_to do |format|
        if @issue.github
          @issue.github.reopen(current_user.github.oauth_token)
        end
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  # PATCH/PUT projects/1/issues/1/postpone
  # PATCH/PUT projects/1/issues/1/postpone.json
  def postpone
    if @issue.update(will_start_at: 1.day.since(Time.now.utc))
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  # PATCH/PUT projects/1/issues/1/do_today
  # PATCH/PUT projects/1/issues/1/do_today.json
  def do_today
    if @issue.update(will_start_at: Time.now.utc)
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  private
    def set_project
      @project = Project.find(params[:project_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:subject, :description, :author_id, :assignee_id)
    end

    def require_member
      project = @project ? @project : @issue.project
      redirect_to root_path, alert: "You are not project member." unless project.member?(current_user)
    end

    def reject_archived
      project = @project ? @project : @issue.project
      redirect_to root_path, alert: "You need to sign in or sign up before continuing." if project.status == Project::STATUS_ARCHIVED
    end
end
