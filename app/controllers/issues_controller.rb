class IssuesController < ApplicationController
  load_and_authorize_resource :project, only: [:index, :new, :create]
  load_and_authorize_resource :issue, except: [:index, :new, :create]
  before_action :load_members, except: [:index, :show, :destroy]
  before_action :load_labels, except: [:index, :show, :destroy]

  def index
    if params[:user_id].present?
      @issues = @project.issues
      .with_status(params[:status])
      .where("assignee_id = ?", params[:user_id])
      .page(params[:page])
      .per(params[:per_page])
    else
      @issues = @project.issues
      .with_status(params[:status])
      .includes(:github, :ruffnote, :comments)
      .page(params[:page])
      .per(params[:per_page])
    end

    respond_to do |format|
      format.json
    end
  end

  def show
  end

  def new
    @issue = @project.issues.build
    authorize! :create, @issue
  end

  def edit
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

        if @issue.project.ruffnote && current_user.ruffnote
          issue = @issue.project.ruffnote.add_issue(current_user.ruffnote.oauth_token , params[:issue])
          if issue
            @issue.add_ruffnote(issue['index'])
          else
            flash[:alert] = 'Create a new issue to Ruffnote failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'new' }
          end
        end

        if issue_params[:continue]
          format.html { redirect_to new_project_issue_path(@project), notice: "Issue was successfully created." }
        else
          format.html { redirect_to @issue, notice: "Issue was successfully created." }
        end
        format.json { render action: 'show', status: :created, location: @issue }
      else
        format.html { render action: 'new' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  rescue Github::Error::GithubError => e
    if e.is_a? Github::Error::ServiceError
      @issue.errors.add(:base, e.body)
    elsif e.is_a? Github::Error::ClientError
      @issue.errors.add(:base, e.message)
    end
    render "new"
  end

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        if issue_params[:enabled_github]
          mediator = GithubMediator.new(
            current_user.github.oauth_token,
            @issue.project.github.full_name
          )
          issue = mediator.create_issue(issue_params)
          if issue
            @issue.add_github(issue)
          else
            flash[:alert] = 'Create a new issue to Github failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'new' }
            return false
          end
        end
        if @issue.project.github && @issue.github
          mediator = GithubMediator.new(
            current_user.github.oauth_token,
            @issue.project.github.full_name
          )
          issue = mediator.edit_issue(issue_params, @issue.github.number)
          if issue
            @issue.add_github(issue)
          else
            flash[:alert] = 'Update a new issue to Github failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'edit' }
            return false
          end
        end

        if @issue.project.ruffnote && current_user.ruffnote
          issue = @issue.ruffnote.modify(
            current_user.ruffnote.oauth_token, issue_params
          )
          unless issue
            flash[:alert] = 'Update a new issue to Ruffnote failed.' + @issue.errors.full_messages.join("\n")
            format.html { render action: 'edit' }
          end
        end

        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render action: "issue" }
      else
        format.html { render action: 'edit' }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  def close
    current_user.stop_time_track

    if @issue.close
      if @issue.github
        mediator = GithubMediator.new(
          current_user.github.oauth_token,
          @issue.project.github.full_name
        )
        issue = mediator.edit_issue({status: 9}, @issue.github.number)
      end
      if @issue.ruffnote
        @issue.ruffnote.close(current_user.ruffnote.oauth_token)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render action: "issue" }
      end
    end
  end

  def reopen
    if @issue.reopen
      if @issue.github
        mediator = GithubMediator.new(
          current_user.github.oauth_token,
          @issue.project.github.full_name
        )
        issue = mediator.edit_issue({status: 1}, @issue.github.number)
      end
      if @issue.ruffnote
        @issue.ruffnote.reopen(current_user.ruffnote.oauth_token)
      end
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render action: "issue" }
      end
    end
  end

  def postpone
    if @issue.update(will_start_at: 1.day.since(Time.now.utc))
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render action: "issue" }
      end
    end
  end

  def do_today
    if @issue.update(will_start_at: Time.now.utc)
      respond_to do |format|
        format.html { redirect_to @issue, notice: 'Issue was successfully updated.' }
        format.json { render action: "issue" }
      end
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:subject, :description, :author_id, :assignee_id, :will_start_at, :status, :continue, :enabled_github, labels: [])
  end

  def load_members
    if params[:project_id]
      # new, create
      if @project.github
        @members = @project.github_members(current_user.github.oauth_token)
      else
        @members = @project.members
      end
    else
      # edit, update
      if @issue.github
        @members = @issue.project.github_members(current_user.github.oauth_token)
      else
        @members = @issue.project.members
      end
    end
  end

  def load_labels
    if params[:project_id]
      # new, create
      if @project.github
        github = Github.new(token: current_user.github.oauth_token)
        owner, repo = @project.github_full_name.split("/")
        @labels = github.issues.labels.list(user: owner, repo: repo)
      end
    else
      # edit, update
      if @issue.github
        github = Github.new(token: current_user.github.oauth_token)
        owner, repo = @issue.project.github_full_name.split("/")
        @labels = github.issues.labels.list(user: owner, repo: repo)
      end
    end
  end
end
