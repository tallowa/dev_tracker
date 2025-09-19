class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :description, presence: true
  validates :start_time, presence: true

   scope :completed, -> { where.not(end_time: nil) }
  scope :in_progress, -> { where(end_time: nil) }

  def duration_in_hours
    return 0 unless start_time && end_time
    (end_time - start_time) / 1.hour
  end

  def in_progress?
    start_time.present? && end_time.blank?
  end



end
