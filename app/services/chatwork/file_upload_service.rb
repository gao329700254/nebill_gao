class Chatwork::FileUploadService < BaseService
  attr_accessor :params

  UPLOAD_FILE_REGEX = %r{\[download:(?<download_id>\d*)\].*?\[/download\]}

  def initialize(params)
    self.params = params
  end

  def execute
    if upload_user.blank?
      logger.info("user not exists chatwork_id: #{webhook_params[:from_account_id]}") && return
    end

    create_expense!
  end

private

  def webhook_params
    @webhook_params ||= begin
      params.require(:webhook_event).tap do |webhook_params|
        %i(from_account_id room_id body).each { |att| webhook_params.require(att) }
      end

      params.require(:webhook_event).permit(%i(from_account_id room_id body)).tap do |webhook_params|
        webhook_params[:download_id] = webhook_params[:body].match(UPLOAD_FILE_REGEX)[:download_id]
      end
    end
  end

  def upload_user
    @upload_user ||= User.find_by_chatwork_id(webhook_params[:from_account_id])
  end

  def default_item
    @default_item ||= DefaultExpenseItem.where(is_receipt: true, is_routing: false).first
  end

  def create_expense!
    expense = upload_user.expenses.build(use_date: Time.zone.today, default: default_item, amount: default_item.standard_amount || 100)

    expense.file.build(attch_uploaded_file_params)

    expense.save!
  end

  def attch_uploaded_file_params
    res = Chatwork::Base.get("v2/rooms/#{webhook_params[:room_id]}/files/#{webhook_params[:download_id]}", create_download_url: 1)

    { file: open(res['download_url']), original_filename: res['filename'] }
  end
end
