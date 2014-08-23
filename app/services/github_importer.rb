class GithubImporter
  def initialize(project)
    raise unless project.github
    @project = project
    @issue_githubs = @project.github_issues
    @owner, @repo = @project.github.full_name.split("/")
    @client = Github.new(oauth_token: @project.admin.github.oauth_token)
  end

  def import_issues
    @client.issues.all(user: @owner, repo: @repo, filter: "all", state: "all").each_page do |github_issues|
      github_issues.each do |github_issue|
        if @issue_githubs.any? { |issue_github| issue_github.number == github_issue.number }
          break
        else
          import_issue(github_issue)
        end
      end
    end
    true
  rescue => e
    Rails.logger.debug "#{e.class}: #{e.message}"
    false
  end

  def import_issue(github_issue)
    Rails.logger.debug "Import ##{github_issue.number} #{github_issue.title} from #{@repository}"
    status = convert_state_to_status(github_issue.state)
    author = generate_temporary_user(github_issue.user.id, github_issue.user.login)
    if github_issue.assignee
      assignee = generate_temporary_user(github_issue.assignee.id, github_issue.assignee.login)
    else
      assignee = nil
    end
    issue = @project.issues.create!(
      subject: github_issue.title,
      description: github_issue.body,
      status: status,
      author: author,
      assignee: assignee,
      closed_on: github_issue.closed_at
    )
    issue.add_github(github_issue)
  end

  private

    def generate_temporary_user(uid, name)
      auth = Authentication.find_by(provider: "github", uid: uid)
      if auth
        user = auth.user
      else
        user = User.create!(email: generate_email, password: generate_password, name: name)
        user.authentications.create!(provider: "github", uid: uid, username: name)
      end
      user
    end

    def generate_email
      "temporary#{User.count+1}@timecard-rails.herokuapp.com"
    end

    def generate_password
      Devise.friendly_token.first(8)
    end

    def convert_state_to_status(state)
      state == "open" ? 1 : 9
    end
end
