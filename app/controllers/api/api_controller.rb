class Api::ApiController < ApplicationController
  rescue_from Exception                   , with: :handle_internal_server_error if Rails.env.produciton?
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def handle_internal_server_error(_ = nil)
    render_internal_server_error_message
  end

  def handle_not_found(_ = nil)
    render_not_found_message
  end

private

  def render_action_model_success_message(model, action)
    render(
      json: {
        id: model.id,
        message: I18n.t("action.#{action}.success", model: I18n.t("activerecord.models.#{model.class.name.underscore}")),
      },
      status: :created,
    )
  end

  def render_action_model_flash_success_message(model, action)
    flash[:success] = I18n.t("action.#{action}.success", model: I18n.t("activerecord.models.#{model.class.name.underscore}"))
    render json: flash, status: :created
  end

  def render_action_model_fail_message(model, action)
    render(
      json: {
        message: I18n.t("action.#{action}.fail", model: I18n.t("activerecord.models.#{model.class.name.underscore}")),
        errors: { messages: model.errors.messages, full_messages: model.errors.full_messages },
      },
      status: :unprocessable_entity,
    )
  end

  def render_internal_server_error_message
    render(
      json: {
        message: t('activerecord.errors.messages.internal_server_error'),
      },
      status: :internal_server_error,
    )
  end

  def render_not_found_message
    render(
      json: {
        message: t('activerecord.errors.messages.not_found'),
      },
      status: :not_found,
    )
  end
end
