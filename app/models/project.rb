class Project < ApplicationRecord
  belongs_to :organization
  has_many :time_entries, dependent: :destroy

  vaidates :name, presence: true




end
