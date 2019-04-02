module Chatwork
  class Client < Base
    attr_accessor :approval, :to_user

    def notify_assigned
      return false unless user_enable?
      send_message(render('client/assigned'))
    end

    def notify_permited
      return false unless user_enable?
      send_message(render('client/permited'))
    end

    def notify_nda_permited
      return false unless user_enable?
      send_message(render('client/nda_permited'))
    end

    def notify_disconfirm
      return false unless user_enable?
      send_message(render('client/disconfirm'))
    end

    def notify_edit
      return false unless users_enable?
      send_message(render('client/edit'))
    end

    def user_enable?
      @to_user&.chatwork_id.present?
    end

    def users_enable?
      @to_user&.all? { |u| u&.chatwork_id.present? }
    end
  end
end
