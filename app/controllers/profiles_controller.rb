class ProfilesController < ApplicationController
  before_action :authenticate_user!

  respond_to :js

  def me
  end

  def avatar_update
    current_user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:avatar)
  end

end
