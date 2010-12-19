class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    callback
  end

  def facebook
    callback
  end

  private

  def callback
    auth = env['omniauth.auth']
    provider = auth['provider']
    user = User.find_by_identity_for(provider, auth['uid'], current_user)

    if user.present?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => provider
      sign_in_and_redirect(user, :event => :authentication)
    else
      session['devise.omniauth_data'] = auth.except('extra')
      redirect_to(new_user_registration_url)
      #redirect_to(new_user_registration_url)
      new_user = User.new_with_session(params, session)
      sign_in_and_redirect(new_user, :event => :authentication)      
    end
  end
end
