module Chatwork
  class ExpenseApproval < Base
    attr_accessor :expense_approval, :to_user

    def notify_assigned
      return false unless user_enable?
      send_message(render('expense_approval/assigned'))
    end

    def notify_permited
      return false unless user_enable?
      send_message(render('expense_approval/permited'))
    end

    def notify_disconfirm
      return false unless user_enable?
      send_message(render('expense_approval/disconfirm'))
    end

    def notify_edit
      return false unless users_enable?
      send_message(render('expense_approval/edit'))
    end

    def user_enable?
      @to_user&.chatwork_id.present?
    end

    def users_enable?
      @to_user&.all? { |u| u&.chatwork_id.present? }
    end
  end
end
