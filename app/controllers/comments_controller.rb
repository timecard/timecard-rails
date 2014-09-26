class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :issue, only: :create
  load_and_authorize_resource :comment, only: [:update, :destroy]

  def create
    if params[:comment_and]
      @issue.toggle_status
    end

    @comment = @issue.comments.build(comment_params)
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        WebsocketRails[:streaming].trigger "create", @comment

        if @comment.issue.ruffnote && current_user.ruffnote
          comment = @comment.issue.ruffnote.add_comment(current_user.ruffnote.oauth_token , comment_params)
          if comment
            @comment.add_ruffnote(comment['id'])
          else
            flash[:alert] = 'Create a new comment to Ruffnote failed.' + @comment.errors.full_messages.join("\n")
            format.html { render action: 'new' }
          end
        end
        format.html { redirect_to @issue, notice: 'Comment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { redirect_to @issue, alert: "Comment was failed created. " + @comment.errors.full_messages.join }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue Github::Error::GithubError => e
    if e.is_a? Github::Error::ServiceError
      @comment.errors.add(:base, e.body)
    elsif e.is_a? Github::Error::ClientError
      @comment.errors.add(:base, e.message)
    end
    redirect_to @issue
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment.issue, notice: 'Comment was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @comment }
      else
        format.html { redirect_to @comment.issue, alert: 'Comment was failed updated.' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  rescue Github::Error::GithubError => e
    if e.is_a? Github::Error::ServiceError
      @comment.errors.add(:base, e.body)
    elsif e.is_a? Github::Error::ClientError
      @comment.errors.add(:base, e.message)
    end
    redirect_to @issue
  end

  def destroy
    if @comment.ruffnote && @comment.ruffnote.comment_id && current_user.ruffnote
      comment = @comment.ruffnote.destroy(
        current_user.ruffnote.oauth_token
      )
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.issue }
      format.json { head :no_content }
    end
  rescue Github::Error::GithubError => e
    if e.is_a? Github::Error::ServiceError
      @comment.errors.add(:base, e.body)
    elsif e.is_a? Github::Error::ClientError
      @comment.errors.add(:base, e.message)
    end
    redirect_to @issue
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
