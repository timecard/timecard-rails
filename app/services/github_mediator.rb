class GithubMediator
  def initialize(token, full_name)
    @owner, @repo = full_name.split("/")
    @client = Github.new(oauth_token: token)
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
end
