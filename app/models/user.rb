class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 has_many :organization_memberships, dependent: :destroy
  has_many :organizations, through: :organization_memberships
  has_many :time_entries, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}".strip
  end






end
