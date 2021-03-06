class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  include User::OmniAuthExtension

  attr_accessible :full_name, :email, :password, :password_confirmation
  validates :full_name, :presence => true

  def full_name_with_email
    "#{self[:full_name]} (#{email})"
  end

  has_many :incident_reports, :dependent => :destroy, :foreign_key => :author_id
  has_many :comments, :dependent => :destroy, :foreign_key => :author_id
  has_many :incident_reports_users, :dependent => :destroy
  
  def role_symbols
    admin? ? [:admin] : [:user]
  end
  
  
  def facebook
    @fb_user ||= FbGraph::User.me(self.identities.find_by_provider('facebook').access_token)
  end
  
end
