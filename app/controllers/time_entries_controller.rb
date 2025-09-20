class TimeEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project
  before_action :set_time_entry, only: [:update, :destroy, :stop]

  def index
    @time_entries = @project.time_entries
                           .includes(:user)
                           .order(created_at: :desc)
    @active_entry = current_user.time_entries.in_progress.find_by(project: @project)
  end

  def create
    # Stop any currently running timer for this user
    current_user.time_entries.in_progress.update_all(end_time: Time.current)
    
    @time_entry = @project.time_entries.build(time_entry_params)
    @time_entry.user = current_user
    @time_entry.start_time = Time.current
    
    if @time_entry.save
      redirect_back(fallback_location: [@project.organization, @project], 
                    notice: 'Timer started!')
    else
      redirect_back(fallback_location: [@project.organization, @project], 
                    alert: 'Could not start timer.')
    end
  end

  def update
    if @time_entry.update(time_entry_params)
      redirect_back(fallback_location: [@project.organization, @project], 
                    notice: 'Time entry updated!')
    else
      redirect_back(fallback_location: [@project.organization, @project], 
                    alert: 'Could not update time entry.')
    end
  end

  def stop
    @time_entry.update!(end_time: Time.current)
    redirect_back(fallback_location: [@project.organization, @project], 
                  notice: 'Timer stopped!')
  end

  def destroy
    @time_entry.destroy
    redirect_back(fallback_location: [@project.organization, @project], 
                  notice: 'Time entry deleted!')
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
    # Ensure user has access to this project through organization membership
    unless current_user.organizations.include?(@project.organization)
      redirect_to root_path, alert: 'Access denied.'
    end
  end

  def set_time_entry
    @time_entry = @project.time_entries.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:description)
  end
end
