class DataController < ApplicationController
  def show
    raise unless current_user
    raise if Member.where(user_id: current_user.id, project_id: params[:id].to_i).blank?
    @project = Project.find(params[:id])
    respond_to do |format|
      format.json { render "show", status: :created, location: @project }
    end
  end

  def create
    pjt = JSON.parse(params[:import].read)
    @project = Project.new(name: pjt["name"])
    @project.save
    if pjt["providers"] && pjt["providers"]["github"]
      pjtg = pjt["providers"]["github"].first
      @project.add_github("#{pjtg["owner_login"]}/#{pjtg["name"]}")
    end
    pjt["issues"].each do |iss|
      issue = Issue.new(subject: iss["subject"], description: iss["description"])
      issue.created_at = Time.at(iss["created_at"])
      issue.updated_at = Time.at(iss["updated_at"])
      # TODO ユーザー情報の引き継ぎが必要
      author = User.find_by(email: iss["author_email"]) || User.new(email: iss["author_email"]).save(validate: false) ? User.find_by(email: iss["author_email"]) : nil
      issue.author_id = author.id
      issue.project_id = @project.id
      issue.save

      if iss["providers"] && iss["providers"]["github"]
        issue.add_github(iss["providers"]["github"]["number"]) 
      end
      iss["workloads"].each do |wl|
        workload = Workload.new
        workload.user_id = User.find_or_create_by(email: wl["user_email"]).id
        workload.start_at = Time.at(wl["start_at"])
        workload.end_at = Time.at(wl["end_at"]) if wl["end_at"]
        workload.issue_id = issue.id
        workload.save
      end

      iss["comments"].each do |cmt|
        comment = Comment.new
        comment.user_id = User.find_or_create_by(email: cmt["user_email"]).id
        comment.body = cmt["body"]
        comment.issue_id = issue.id
        comment.save
      end
    end
    redirect_to project_path(@project)
  end
end
