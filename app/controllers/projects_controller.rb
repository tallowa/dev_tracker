class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def show
    @time_entries = @project.time_entries
                           .includes(:user)
                           .order(created_at: :desc)
                           .limit(50)
    @active_entry = current_user.time_entries.in_progress.find_by(project: @project)
  end

  def new
    @project = @organization.projects.build
  end

  def create
    @project = @organization.projects.build(project_params)
    
    if @project.save
      redirect_to [@organization, @project], notice: 'Project created successfully!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to [@organization, @project], notice: 'Project updated successfully!'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to @organization, notice: 'Project deleted successfully!'
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:organization_id])
  end

  def set_project
    @project = @organization.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end
end
