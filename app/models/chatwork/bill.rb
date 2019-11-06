module Chatwork
  class Bill < Base
    attr_accessor :bill, :to_user, :from_user

    def notify_assigned
      return false unless user_enable?
      send_message(render('bill/assigned'))
    end

    def notify_approved
      return false unless user_enable?
      send_message(render('bill/approved'))
    end

    def notify_sent_back
      return false unless user_enable?
      send_message(render('bill/sent_back'))
    end

    def user_enable?
      @to_user&.chatwork_id.present?
    end
  end
end
