class DashboardController < ApplicationController
before_action :authenticate_user!

  def index
    @organizations = current_user.organizations
    @recent_time_entries = current_user.time_entries
                                      .includes(:project)
                                      .order(created_at: :desc)
                                      .limit(10)
    @active_time_entry = current_user.time_entries.in_progress.first
  end
end
