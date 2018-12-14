class Ability
  include CanCan::Ability

  def initialize(user)
    can :home, Page
    can :manage, UserSession

    return unless user.present?

    case user.role
    when 'general', 'superior'
      defaultcan user
    when 'admin', 'backoffice'
      admincan user
    end
  end

private

  def defaultcan(user)
    can :manage, Page
    can :manage, Client
    can :manage, Project
    can :manage, ProjectGroup
    can :manage, UserMember
    can :manage, ProjectFile
    can :manage, Member
    can :manage, Bill

    approval_ability
    expense_abilty user

    can :read, ProjectFileGroup
    can :create, ProjectFileGroup

    can :read, Partner
    can :create, Partner
    can :update, Partner
    can :read, User
    can :cd, ProjectCd
    can :search_result, Bill
    can :download, Bill
    can :download, Xlsx
    can :download, Pdf
    can :approval_file_download, File
    can :expense_file_download, File
  end

  def admincan(user)
    can :manage, :all
    can :allread, Approval
    can :allread, ExpenseApproval
    cannot :reapproval, ExpenseApproval, status: [10, 20, 40] # 差し戻しの場合、再申請できる
    [3, 7].exclude?(user.id) && cannot(:manage, PayeeAccount) # 全銀データ出力をいじりたいときはこの行をコメントにする
  end

  def approval_ability
    can :manage, Approval
    can :manage, ApprovalUser
    can :manage, ApprovalFile
    cannot :allread, Approval
  end

  def expense_abilty(user)
    can :manage, Expense, expense_approval_id: nil, created_user_id: user.id                  # 自分が作成した経費かつ未申請のものには全権限を持つ
    can [:update, :destroy, :create], Expense, expense_approval: { status: [10, 30] }, created_user_id: user.id
    # 自分が作成した経費かつステータスが承認待ちまたは差し戻しのものには更新と削除,登録権限を持つ
    can :read, Expense                          # そうでなくても、読み取り権限を持つ

    can :manage, ExpenseFile

    can [:read, :create, :update, :destroy, :search_result], ExpenseApproval
    can :reapproval, ExpenseApproval, status: [30], created_user_id: user.id # 差し戻しの場合、再申請できる
    can [:renewal, :ex_create], ExpenseApproval, status: [10, 30], created_user_id: user.id # 承認待ちまたは差し戻しの場合、更新できる

    can :manage, ExpenseApprovalUser
  end
end
