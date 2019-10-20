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

  def bill_list
    @bills = Bill.joins(:bill_approval_users)
                 .where(bill_approval_users: { status: 'pending', user_id: @current_user.id })
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
