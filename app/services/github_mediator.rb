class GithubMediator
  def initialize(token, full_name)
    @owner, @repo = full_name.split("/")
    @client = Github.new(oauth_token: token)
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

  def create_comment(params, number)
    comment = @client.issues.comments.create(
      @owner, @repo, number, body: params[:body]
    )
    comment
  rescue ArgumentError
    Rails.logger.info "ArgumentError: #{@owner}, #{@repo}, #{params}"
    nil
  rescue => e
    Rails.logger.info "#{e.class}: #{@owner}, #{@repo}, #{params}"
    nil
  end

  def edit_comment(params, comment_id)
    options = {}
    options["body"] = params[:body] if params[:body]
    comment = @client.issues.comments.edit(
      @owner, @repo, comment_id, options
    )
    comment
  rescue ArgumentError
    Rails.logger.info "ArgumentError: #{@owner}, #{@repo}, #{params} #{comment_id}"
    nil
  rescue => e
    Rails.logger.info "#{e.class}: #{@owner}, #{@repo}, #{params} #{comment_id}"
    nil
  end

  def destroy_comment(comment_id)
    @client.issues.comments.delete(
      @owner, @repo, comment_id
    )
  rescue ArgumentError
    Rails.logger.info "ArgumentError: #{@owner}, #{@repo}, #{comment_id}"
    nil
  rescue => e
    Rails.logger.info "#{e.class}: #{@owner}, #{@repo}, #{comment_id}"
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
    if params[:labels].present?
      options["labels"] = []
      params[:labels].each do |label|
        options["labels"] << label
      end
    end
    options
  end
end
