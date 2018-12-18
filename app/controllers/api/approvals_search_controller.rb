class Api::ApprovalsSearchController < Api::ApiController
  def index
    @approvals = search_approval.only_approval
    render template: 'api/approvals/index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

private

  def search_approval
    if params[:created_at].present? && can?(:allread, Approval)
      Approval.where_created_on(params[:created_at]).includes(:created_user)
    elsif params[:created_at].present?
      Approval.related_approval_where_created_on(current_user.id, params[:created_at])
              .includes([:created_user, [users: :employee], :approval_users])
              .references(:approval_users)
    elsif can?(:allread, Approval)
      Approval.includes([:created_user, [users: :employee], :approval_users])
    else
      Approval.related_approval(current_user.id)
              .includes([:created_user, [users: :employee], :approval_users])
              .references(:approval_users)
    end
  end
end
