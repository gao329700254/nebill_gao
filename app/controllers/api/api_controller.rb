class Api::ApiController < ApplicationController
private

  def render_action_model_success_message(model, action)
    render(
      json: {
        id: model.id,
        message: I18n.t("action.#{action}.success", model: I18n.t("activerecord.models.#{model.class.name.downcase}")),
      },
      status: :created,
    )
  end

  def render_action_model_fail_message(model, action)
    render(
      json: {
        message: I18n.t("action.#{action}.fail", model: I18n.t("activerecord.models.#{model.class.name.downcase}")),
        errors: { messages: model.errors.messages, full_messages: model.errors.full_messages },
      },
      status: :unprocessable_entity,
    )
  end
end
