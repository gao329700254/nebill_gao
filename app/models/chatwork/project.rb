module Chatwork
  class Project < Base
    attr_accessor :approval, :to_user

    def notify_assigned
      return false unless user_enable?
      send_message(render('project/assigned'))
    end

    def notify_permited
      return false unless user_enable?
      send_message(render('project/permited'))
    end

    def notify_disconfirm
      return false unless user_enable?
      send_message(render('project/disconfirm'))
    end

    def notify_edit
      return false unless users_enable?
      send_message(render('project/edit'))
    end

    def user_enable?
      @to_user&.chatwork_id.present?
    end

    def users_enable?
      @to_user&.all? { |u| u&.chatwork_id.present? }
    end
  end
end
