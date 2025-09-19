class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update]

  def index
    @organizations = current_user.organizations
  end

  def show
    @projects = @organization.projects
    @recent_time_entries = @organization.time_entries
                                       .includes(:user, :project)
                                       .order(created_at: :desc)
                                       .limit(20)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    
    if @organization.save
      # Make the creator an owner
      OrganizationMembership.create!(
        user: current_user,
        organization: @organization,
        role: 'owner'
      )
      redirect_to @organization, notice: 'Organization created successfully!'
    else
      render :new
    end
  end

  private

  def set_organization
    @organization = current_user.organizations.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
