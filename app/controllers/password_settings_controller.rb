class PasswordSettingsController < ApplicationController
  def edit
    @user = User.find_using_perishable_token(params[:id], 1.week)
    fail ActiveRecord::RecordNotFound unless @user

    @password_setting = PasswordSetting.new(id: params[:id])
    render layout: 'simple'
  end

  def update
    @user = User.find_using_perishable_token(params[:id], 1.week)
    fail ActiveRecord::RecordNotFound unless @user

    @user.assign_attributes(password_setting_params)

    if @user.save(context: :confirm)
      redirect_to project_list_path
    else
      @password_setting = PasswordSetting.new(id: params[:id])
      render :edit, layout: 'simple'
    end
  end

  def password_setting_params
    params.require(:password_setting).permit(:password, :password_confirmation)
  end
end
