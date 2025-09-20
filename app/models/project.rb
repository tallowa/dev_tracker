class Project < ApplicationRecord
  belongs_to :organization
  has_many :time_entries, dependent: :destroy

  validates :name, presence: true




end
