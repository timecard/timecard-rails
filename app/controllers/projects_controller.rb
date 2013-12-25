class ProjectsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :archive, :active, :close]
  before_action :reject_archived, except: [:index, :new, :create, :active]
  before_action :require_admin, only: [:edit, :update, :destroy, :archive, :active, :close]
  before_action :require_member, only: [:show]

  def index
    status = params[:status] || 1
    if user_signed_in?
      case status.to_i
      when Project::STATUS_ACTIVE
        public_projects = Project.public.active.where_values.reduce(:and)
        my_projects = Project.active.visible(current_user).where_values.reduce(:and)
      when Project::STATUS_CLOSED
        public_projects = Project.public.closed.where_values.reduce(:and)
        my_projects = Project.closed.visible(current_user).where_values.reduce(:and)
      when Project::STATUS_ARCHIVED
        public_projects = Project.public.archive.where_values.reduce(:and)
        my_projects = Project.archive.visible(current_user).where_values.reduce(:and)
      end
      @projects = Project.where(public_projects.or(my_projects))
    else
      @projects =  case status.to_i
                   when Project::STATUS_ACTIVE
                     Project.public.active
                   when Project::STATUS_CLOSED
                     Project.public.closed
                   when Project::STATUS_ARCHIVED
                     Project.public.archive
                   end
    end

    respond_to do |format|
      format.html
      format.json { render action: "index", status: :ok }
    end
  end

  def show
    @title = @project.name
    @issues = @project.issues.with_status("open")
    @comments = Comment.where(issue_id: @project.issues.pluck(:id)).order("updated_at DESC").limit(10)
    @workloads = Workload.where(issue_id: @project.issues.pluck(:id)).complete.order("updated_at DESC").limit(10)
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        m = Member.new(user: current_user, is_admin: true)
        @project.members << m
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.modify(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def archive
    respond_to do |format|
      if @project.update(status: Project::STATUS_ARCHIVED)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def active
    respond_to do |format|
      if @project.update(status: Project::STATUS_ACTIVE)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def close
    respond_to do |format|
      if @project.update(status: Project::STATUS_CLOSED)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      res = params.require(:project).permit(:name, :description, :is_public, :parent_id, :status)
      res["github_full_name"] = params["project"]["github_full_name"].gsub(/ 　/,"") unless params["project"]["github_full_name"].blank?
      res["ruffnote_full_name"] = params["project"]["ruffnote_full_name"].gsub(/ 　/,"") unless params["project"]["ruffnote_full_name"].blank?
      return res
    end

    def require_admin
      return redirect_to root_path, alert: "You are not project admin." unless @project.admin?(current_user)
    end

    def require_member
      return if @project.is_public
      return redirect_to root_path, alert: "You are not project member." unless @project.member?(current_user)
    end

    def reject_archived
      return redirect_to root_path, alert: "You need to sign in or sign up before continuing." if @project.status == Project::STATUS_ARCHIVED
    end
end
