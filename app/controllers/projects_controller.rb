class ProjectsController < ApplicationController
  load_and_authorize_resource except: [:index, :new, :create]

  def index
    status = params[:status] || 1
    if user_signed_in?
      public_projects = Project.public.status(status).where_values.reduce(:and)
      my_projects = Project.status(status).visible(current_user).where_values.reduce(:and)
      @projects = Project.where(public_projects.or(my_projects))
    else
      @projects = Project.public.status(status)
    end

    render action: "index", status: :ok
  end

  def show
    @title = @project.name
    @issues = @project.issues.with_status("open")
    @comments = Comment.where(issue_id: @project.issues.pluck(:id)).order("updated_at DESC").limit(10)
    @workloads = Workload.where(issue_id: @project.issues.pluck(:id)).complete.order("updated_at DESC").limit(10)
  end

  def new
    @project = Project.new
    authorize! :create, @project
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    authorize! :create, @project
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
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render action: 'show' }
      else
        format.html { render action: 'edit' }
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
      res = params.require(:project).permit(:name, :description, :is_public, :parent_id, :status, :crowdworks_url)
      res["github_full_name"] = params["project"]["github_full_name"].gsub(/ 　/,"") unless params["project"]["github_full_name"].blank?
      res["ruffnote_full_name"] = params["project"]["ruffnote_full_name"].gsub(/ 　/,"") unless params["project"]["ruffnote_full_name"].blank?
      return res
    end

    def require_member
      return if @project.is_public
      return redirect_to root_path, alert: "You are not project member." unless @project.member?(current_user)
    end
end
