class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:concord_portal]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :token

  def self.find_for_concord_portal_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      email = auth.info.email || "#{Devise.friendly_token[0,20]}@example.com"
      user = User.create(provider:auth.provider,
                         uid:     auth.uid,
                         email:   email,
                         password:Devise.friendly_token[0,20]
                        )
    end
    user.token = auth.credentials.token
    user.save
    user
  end
end
