class Api::SendPasswordSettingEmailsController < Api::ApiController
  def create
    @user = User.find(params[:user_id])

    @user.send_password_setting_email
    render json: {
      id: @user.id,
      message: I18n.t("action.send_email.success"),
    },
           status: :created
  rescue
    render json: {
      message: I18n.t("action.send_email.fail"),
      errors: { messages: @user.errors.messages, full_messages: @user.errors.full_messages },
    },
           status: :unprocessable_entity
  end
end
