class Organization < ApplicationRecord
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships
  has_many :projects, dependent: :destroy
  has_many :time_entries, through: :projects

  validates :name, presence: true

end
