class HooksController < ApplicationController
  skip_authorize_resource only: [:create]
  before_action :check_signature

  protect_from_forgery except: :create

  def create
    Chatwork::FileUploadService.new(params).execute if direct_chat_file_upload?

    head :ok
  # すべてのエラーを拾って 200を返す
  rescue => e
    Rails.logger.error e
    Rails.logger.error e.backtrace
    head :ok
  end

private

  def check_signature
    digest = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'),  Base64.decode64(ENV['CHATWORK_WEB_HOOK_TOKEN']), request.body.read)

    head :forbidden unless request.headers[:HTTP_X_CHATWORKWEBHOOKSIGNATURE] == Base64.strict_encode64(digest)
  end

  def direct_chat_file_upload?
    return false unless direct_chat?
    return false unless params.dig(:webhook_event, :body).match(Chatwork::FileUploadService::UPLOAD_FILE_REGEX).present?

    true
  end

  def direct_chat?
    res = Chatwork::Base.get("v2/rooms/#{params.dig(:webhook_event, :room_id)}")
    res && res['type'] == 'direct'
  end
end
