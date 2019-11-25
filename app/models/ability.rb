class Ability
  include CanCan::Ability

  def initialize(user)
    can :home, Page
    can :manage, UserSession
    can :manage, PasswordSetting

    return unless user.present?

    case user.role
    when 'outer'
      outercan
    when 'general', 'superior'
      defaultcan user
    when 'admin', 'backoffice'
      admincan
    end
  end

private

  def outercan
    can [:approval_list, :project_list, :expense_approval_list], Agreement
    can [:approval_list, :approval_show, :agreement_list], Page
    can :manage, ApprovalsSearch
    can [:update, :read, :invalid], Approval
    can [:read, :update], ApprovalUser
    can :read, ApprovalFile
    cannot :allread, Approval
  end

  def defaultcan(user)
    can :manage, Agreement
    can :manage, Page
    can [:read, :create, :update, :destroy, :statuses, :published_clients], Client
    can :manage, Project
    can :manage, ProjectGroup
    can :manage, UserMember
    can :manage, ProjectFile
    can :manage, Member
    can :manage, ApprovalsSearch
    can :manage, ProjectCd

    approval_ability
    expense_abilty user
    bill_ability user

    can :read, ProjectFileGroup
    can :create, ProjectFileGroup

    can :read, Partner
    can :create, Partner
    can :update, Partner
    can :read, User
    can :cd, ProjectCd
    can :download, Xlsx
    can :download, Pdf
    # NEBILL-328 ability.rbのエラー原因の調査
    # staging環境ではエラーが出たので、下の行をコメントアウト
    # can :download, Csv
    can :approval_file_download, File
    can :expense_file_download, File
  end

  def admincan
    can :manage, :all
    can :allread, Approval
    can :allread, ExpenseApproval
    cannot :reapproval, ExpenseApproval, status: [10, 20, 40] # 差し戻しの場合、再申請できる
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

    can [:read, :create, :update], ExpenseApproval
    can :reapproval, ExpenseApproval, status: 'disconfirm', created_user_id: user.id # 差し戻しの場合、再申請できる
    can :disconfirm, ExpenseApproval, status: 'permission', expense_approval_user: { expense_approval_id: user.id } # 承認者は、承認済みのとき差戻できる
    can [:renewal, :ex_create], ExpenseApproval, status: %w(pending disconfirm), created_user_id: user.id # 承認待ちまたは差し戻しの場合、更新できる

    can :manage, ExpenseApprovalUser
  end

  def bill_ability(user)
    can [:read, :create, :search_result], Bill
    can [:update, :destroy], Bill,             create_user_id: user.id
    can :create,             BillApplicant
    can :update,             BillApplicant,    bill: { create_user_id: user.id }
    can :manage,             BillApprovalUser
    can :search_result,      Bill
    can :download,           Bill
  end
end
