class GithubMediator
  def initialize(token, full_name)
    @owner, @repo = full_name.split("/")
    @client = Github.new(oauth_token: token)
  end

  def create_issue(params)
    options = issue_options_from_params(params)
    issue = @client.issues.create(
      @owner, @repo, options
    )
    issue
  rescue ArgumentError
    Rails.logger.info "ArgumentError: #{@owner}, #{@repo}, #{options}"
    nil
  rescue => e
    Rails.logger.info "#{e.class}: #{@owner}, #{@repo}, #{options}"
    nil
  end

  def edit_issue(params, number)
    options = issue_options_from_params(params)
    issue = @client.issues.edit(
      @owner, @repo, number, options
    )
    issue
  rescue ArgumentError
    Rails.logger.info "ArgumentError: #{@owner}, #{@repo}, #{options}"
    nil
  rescue => e
    Rails.logger.info "#{e.class}: #{@owner}, #{@repo}, #{options}"
    nil
  end

  private

  def issue_options_from_params(params)
    options = {}
    options["title"] = params[:subject] if params[:subject]
    options["body"] = params[:description] if params[:description]
    case params[:status]
    when 1
      options["state"] = "open"
    when 9
      options["state"] = "close"
    end
    if params[:assignee_id].present?
      user = User.find(params[:assignee_id])
      options["assignee"] = user.github.username
    else
      options["assignee"] = nil
    end
    if params[:assignee_id].blank?
      options["assignee"] = nil
    else
      user = User.find(params[:assignee_id])
      options["assignee"] = user.github.username
    end
    if params[:github_labels].present?
      options["labels"] = []
      params[:github_labels].each do |key, value|
        options["labels"] << value
      end
    end
    options
  end
end
