class IssuesController < ApplicationController
  load_and_authorize_resource :project, only: [:index, :new, :create]
  load_and_authorize_resource :issue, except: [:index, :new, :create]

  def index
    status = params[:status] || "open"
    if @project.present?
      if params[:user_id].present?
        @issues = @project.issues.with_status(status).where("assignee_id = ?", current_user.id)
      else
        @issues = @project.issues.with_status(status)
      end
    end

    respond_to do |format|
      format.js
      format.json { render action: "index", status: :ok }
    end
  end

  def show
    @title = @issue.subject
    @project = Project.find(@issue.project_id)
  end

  def new
    @issue = @project.issues.build
    authorize! :create, @issue
  end

  def edit
    if @issue.github
      github = Github.new(oauth_token: current_user.github.oauth_token)
      owner, repo = @issue.project.github.full_name.split("/")
      @collaborators = github.repos.collaborators.list(owner, repo).map { |cbr| cbr.login }
      @members = Member.where(
        project_id: @issue.project.id,
        user_id: Authentication.where(provider: "github", username: @collaborators).pluck(:user_id)
      )
    end
  end

  def create
    @issue = @project.issues.build(issue_params)
    authorize! :create, @issue
    respond_to do |format|
      if @issue.save
        if Authentication.exists?(["provider = 'chatwork'"])
          rails_host = env["HTTP_HOST"]
          body = "#{current_user.name}さんが「#{@issue.project.name}」に「#{@issue.subject}」を追加しました\nhttp://#{rails_host}/issues/#{@issue.id}"
          Chatwork.post(body)
        end

        if params[:github].present?
          issue = @issue.project.github.add_issue(current_user.github.oauth_token , params[:issue])
          if issue
            @issue.add_github(issue)
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
        if params[:github].present?
          issue = @issue.project.github.add_issue(current_user.github.oauth_token , params[:issue])
          if issue
            @issue.add_github(issue)
          else
            flash[:alert] = 'Create a new issue to Github failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'new' }
            return false
          end
        end
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
    if current_user.work_in_progress?(@issue)
      current_user.running_workload.update(end_at: Time.now.utc)
    end

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

  def issue_params
    params.require(:issue).permit(:subject, :description, :author_id, :assignee_id, :will_start_at)
  end
end
