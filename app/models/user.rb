class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:github, :ruffnote]

  has_many :authentications, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :issues, class_name: "Issue", foreign_key: "assignee_id"
  has_many :comments
  has_many :workloads

  validates :name, presence: true
  validates :name, uniqueness: true

  def apply_omniauth_with_github(omniauth)
    self.email = omniauth.info.email if self.email.blank?
    self.password = Devise.friendly_token[0,20] if self.encrypted_password.blank?
    authentications.build(
      provider: omniauth.provider,
      uid: omniauth.uid,
      username: omniauth.info.nickname,
      oauth_token: omniauth.credentials.token
    )
  end

  def github_username
    github.username
  end

  def github
    authentications.where(provider: "github").first
  end

  def apply_omniauth_with_ruffnote(omniauth)
    self.email = omniauth.info.email if self.email.blank?
    self.password = Devise.friendly_token[0,20] if self.encrypted_password.blank?
    authentications.build(
      provider: omniauth.provider,
      uid: omniauth.uid,
      username: omniauth.info.nickname,
      oauth_token: omniauth.credentials.token
    )
  end

  def ruffnote_username
    ruffnote.username
  end

  def ruffnote
    authentications.where(provider: "ruffnote").first
  end

  def connected?(provider)
    authentications.where(provider: provider).exists?
  end
end
