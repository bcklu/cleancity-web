module User::OmniAuthExtension
  extend ActiveSupport::Concern

  included do
    has_many :identities, :class_name => 'UserIdentity', :dependent => :destroy
    devise :omniauthable
  end

  module ClassMethods
    # Find user by omniauth uid for specified provider
    # Or create new identity if user given
    #
    def find_by_identity_for(provider, uid, access_token, current_user)
      identity = UserIdentity.find_by_provider_and_uid(provider, uid)
      # check if we have an access token
      identity.update_attributes(:access_token => access_token) if identity.access_token.nil?
      return identity.user if identity

      if current_user
        current_user.identities.create!(:provider => provider, :uid => uid, :access_token => access_token)
        return current_user
      end

      nil
    end

    # Used by devise for initializing new User, received both params and session.
    # Builds aomniauth identity and fills user fields if omniauth data presents in the session
    #
    def new_with_session(params, session)
      super.tap do |user|
        if data = session['devise.omniauth_data']
          user.email = data['extra']['user_hash']['email'] if user.email.blank? && data['extra']['user_hash']['email'].present?
          user.full_name = data['extra']['user_hash']['name'] if user.full_name.blank? && data['extra']['user_hash']['name'].present?
          user.password = Devise.friendly_token[0,20]
          user.skip_confirmation!
          user.save


          user.identities.build(
              :provider => data['provider'],
              :uid => data['uid'],
              :access_token => data['credentials']['token'])
        end
      end
    end
  end

  module InstanceMethods
    def password_required?
      (identities.empty? || !password.blank? || !password_confirmation.blank?) && super
    end

    def valid_password?(password)
      return super if password_stored?
      true
    end

    def password_stored?
      encrypted_password_was.present?
    end
  end
end
