class Api::AgreementsController < Api::ApiController
  def approval_list
    @approvals = Approval.where(approved_type: [nil, ''])
                         .where('approval_users.user_id = ?', current_user.id)
                         .where('approval_users.status = 10')
                         .includes([[created_user: :employee], :approval_users])
                         .references(:approval_users)
    render template: 'api/approvals/index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def client_list
    users = ApprovalUser.where(status: 10)
    @client = Client.includes(:approvals).where(approvals: { id: users.pluck(:approval_id) })
    render template: 'api/clients/agreement_client', formats: 'json', status: :ok
  end

  def project_list
    users = ApprovalUser.where(status: 10, user_id: @current_user.id)
    @project = Project.includes(:approvals).where(approvals: { id: users.pluck(:approval_id) })
    render 'api/projects/agreement_project', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  # ログインユーザがis_chiefであるとき、一段目承認者が承認した申請のみを表示する
  # ログインユーザがis_chiefでないとき、自分が一段目承認者に設定されており、自分のステータスが承認待ちの申請を表示する
  def bill_list
    @bills = if @current_user.is_chief?
               Bill.assigned_to_me(@current_user.id) & Bill.only_approved_by_primary
             else
               Bill.assigned_to_me(@current_user.id)
             end

    render 'api/bills/agreement_bill', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def expense_approval_list
    @expense_approvals = ExpenseApproval.includes([[created_user: :employee], :expense_approval_user])
                                        .references(:expense_approval_user)
                                        .where('expense_approval_users.user_id = ?', current_user.id)
                                        .where('expense_approval_users.status = ?', '10')
    render template: 'api/expense_approvals/index', formats: 'json', handlers: 'jbuilder', status: :ok
  end
end
