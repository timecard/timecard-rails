class IssuesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: [:index, :new, :create]
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :close, :reopen, :postpone, :do_today]
  before_action :reject_archived
  before_action :require_member, except: [:index, :show]

  def index
    status = params[:status] || "open"
    @issues = @project.issues.with_status(params[:status])

    respond_to do |format|
      format.js
    end
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
    @title = @issue.subject
  end

  def new
    @issue = @project.issues.build
  end

  def edit
    if @issue.github
      github = Github.new(oauth_token: current_user.github.oauth_token)
      # FIXME full_nameを保存するときにスペースは取り除くべき
      owner, repo = @issue.project.github.full_name.gsub(/\s*/, "").split("/")
      @collaborators = github.repos.collaborators.list(owner, repo).map { |cbr| cbr.login }
      @members = Member.where(
        project_id: @issue.project.id,
        user_id: Authentication.where(provider: "github", username: @collaborators).pluck(:user_id)
      )
    end
  end

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

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        if @issue.project.github && @issue.github
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

  def close
    if @issue.close
      if @issue.github
        @issue.github.close(current_user.github.oauth_token)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  def reopen
    if @issue.reopen
      if @issue.github
        @issue.github.reopen(current_user.github.oauth_token)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  def postpone
    if @issue.update(will_start_at: 1.day.since(Time.now.utc))
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

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
      params.require(:issue).permit(:subject, :description, :author_id, :assignee_id, :will_start_at)
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
