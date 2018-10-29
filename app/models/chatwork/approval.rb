module Chatwork
  class Approval < Base
    attr_accessor :approval, :to_user

    def notify_assigned
      return false unless user_enable?
      send_message(render('approval/assigned'))
    end

    def notify_permited
      return false unless user_enable?
      send_message(render('approval/permited'))
    end

    def notify_disconfirm
      return false unless user_enable?
      send_message(render('approval/disconfirm'))
    end

    def notify_edit
      return false unless user_enable?
      send_message(render('approval/edit'))
    end

    def user_enable?
      @to_user&.chatwork_id.present?
    end
  end
end
