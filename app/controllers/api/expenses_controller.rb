# rubocop:disable Metrics/ClassLength
class Api::ExpensesController < Api::ApiController
  def index
    @expense_approval = ExpenseApproval.my_appr(@current_user.id)
    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def load_list
    if params[:selectedApproval] == '0'
      @expenses = Expense.where(expense_approval_id: nil, created_user_id: @current_user.id).includes(:default, :file)
    else
      @eappr = ExpenseApproval.find(params[:selectedApproval])
      @expenses = @eappr.expense.includes(:default, :file)
    end
    render 'load', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def create
    @expense = Expense.new(expense_param)
    # set_session
    @expense.transaction do
      @expense.default_id = params[:default_expense_item][:name]
      @expense.created_user_id = @current_user.id
      @expense.save!
      update_total_expense(expense: @expense)
      file_param.present? && file_create
    end
    action_model_flash_success_message(@expense, :create)
    redirection_path

  rescue ActiveRecord::RecordInvalid
    flash[:error] = "#{I18n.t('action.create.fail', model: I18n.t("activerecord.models.#{@expense.class.name.underscore}"))}"\
                              " \n #{@expense.errors.full_messages.join('<br>')}"
    # redirect_to expense_new_path
    set_redirection_data

    render template: "pages/expense_new"
  end

  def update
    @expense = Expense.find(params[:id])
    @expense.transaction do
      @expense.default_id = params[:default_expense_item][:name]
      @expense.update(expense_param)
      file_param.present? && edit_file
      @expense.save!
      update_total_expense(expense: @expense)
    end
    action_model_flash_success_message(@expense, :update)
    redirect_to expense_list_path
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "#{I18n.t('action.create.fail', model: I18n.t("activerecord.models.#{@expense.class.name.underscore}"))}"\
                              " \n #{@expense.errors.full_messages.join('<br>')}"
    redirect_to(:back)
  end

  def input_item
    @list = DefaultExpenseItem.find(params[:defaule_expense_items])
    render json: @list, status: :ok
  end

  def load_item
    @list = Expense.find(params[:expense_id]).default
    render json: @list, status: :ok
  end

  def destroy
    @expense = Expense.find(params[:id])
    if @expense.destroy
      render_action_model_flash_success_message(@expense, :destroy)
    else
      render_action_model_fail_message(@user, :destroy)
    end
  end

  def create_expense_approval
    @expense_approval = ExpenseApproval.new
    @expense_approval[:notes] = params[:notes]
    @expense_approval[:total_amount] = params[:total_amount]
    @expense_approval[:expenses_number] = params[:selected].count
    @expense_approval[:name] = "#{ExpenseApproval.appr_id + 1}#{@current_user.name}経費精算申請" + params[:total_amount]
    @expense_approval[:created_user_id] = @current_user.id
    if @expense_approval.save!
      save_expense_group
      save_expense_approval_user
      render_action_model_success_message(@expense_approval, :create)
    else
      render_action_model_fail_message(@expense_approval, :create)
    end
  end

  def reapproval
    @expense_approval = ExpenseApproval.find(params[:selectedApproval])
    @expense_approval.transaction do
      @expense_approval.update!(status: 10)
      @expense_approval.users.each do |user|
        ExpenseApprovalMailer.update_expense_approval(user: user, expense_approval: @expense_approval).deliver_now
        Chatwork::ExpenseApproval.new(expense_approval: @expense_approval, to_user: @expense_approval.created_user).notify_edit
      end
    end
    render_action_model_flash_success_message(@expense_approval, :update)
  rescue
    render_action_model_fail_message(@expense_approval, :update)
  end

  def invalid_approval
    @expense_approval = ExpenseApproval.find(params[:selectedApproval])
    @expense_approval.transaction do
      @expense_approval.update!(status: 40)
    end
    render_action_model_flash_success_message(@expense_approval, :invalid)
  rescue
    render_action_model_fail_message(@expense_approval, :invalid)
  end

  def search_for_csv
    @st = params[:start]
    @end = params[:end]
    @expenses = if @st.present? && @end.present?
                  Expense.approval_id_not_nil.between(@st, @end).includes([:default, { expense_approval: [:created_user, :expense_approval_user] }])
                elsif @st.present?
                  Expense.approval_id_not_nil.gteq_start_on(@st).includes([:default, { expense_approval: [:created_user, :expense_approval_user] }])
                elsif @end.present?
                  Expense.approval_id_not_nil.lteq_end_on(@end).includes([:default, { expense_approval: [:created_user, :expense_approval_user] }])
                else
                  Expense.approval_id_not_nil.includes([:default, { expense_approval: [:created_user, :expense_approval_user] }])
                end
    render 'search_for_csv', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def expense_history
    @st = params[:station]
    @no = params[:note]
    @id = params[:default_id]

    @expenses = if @st.present? && @no.present?
                  Expense.where(created_user_id: @current_user.id)
                         .where('depatture_location = ? OR arrival_location = ?', @st, @st)
                         .where('notes LIKE ?', "%#{@no}%").includes(:default, :file)
                elsif @st.present?
                  Expense.where(created_user_id: @current_user.id)
                         .where('depatture_location = ? OR arrival_location = ?', @st, @st).includes(:default, :file)
                elsif @no.present?
                  Expense.where(created_user_id: @current_user.id)
                         .where('notes LIKE ?', "%#{@no}%").includes(:default, :file)
                else
                  Expense.where(created_user_id: @current_user.id).includes(:default, :file)
                end

    render 'load', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def set_default_items
    @default_expense_items = DefaultExpenseItem.select(:name, :display_name).all
    render json: @default_expense_items, status: :ok
  end

private

  def expense_param
    params.require(:expense).permit(
      :use_date,
      :depatture_location,
      :arrival_location,
      :amount,
      :quantity,
      :notes,
      :payment_type,
      :expense_approval_id,
    )
  end

  def save_expense_group
    @expenses = Expense.find(params[:selected])
    @expenses.each do |expenses|
      expenses.update!(expense_approval_id: @expense_approval.id)
    end
  end

  def save_expense_approval_user
    @expense_approval_user = @expense_approval.expense_approval_user.build(
      expense_approval_id: @expense_approval.id,
      user_id: @current_user.default_allower,
    )
    @expense_approval_user.save!
    ExpenseApprovalMailer.assignment_user(user: @expense_approval_user.user, expense_approval: @expense_approval).deliver_now
    Chatwork::ExpenseApproval.new(expense_approval: @expense_approval, to_user: @expense_approval_user.user).notify_assigned
  end

  def file_param
    params.require(:expense).permit(
      file_attributes: [:file],
    )
  end

  def update_total_expense(expense:)
    return if expense[:expense_approval_id].blank?
    @eappr = ExpenseApproval.find(expense[:expense_approval_id])
    @eappr[:total_amount] = @eappr.expense.sum(:amount)
    @eappr[:expenses_number] = @eappr.expense.count
    @eappr.save!
  end

  def file_create
    file = file_param[:file_attributes].first.second[:file]
    file=@expense.file.build(file: file, original_filename: file.original_filename)
    file.save!
  end

  def edit_file
    new_file =file_param[:file_attributes].first.second[:file]
    if @expense.file.present?
      uploaded_file = @expense.file.first
      if params[:__delete].present?
        # ファイルを削除する
        uploaded_file.destroy!
      elsif new_file.present?
        # ファイルを更新する
        uploaded_file.update!(file: new_file, original_filename: new_file.original_filename)
      end
    elsif params[:__delete].blank?
      # ファイルを作成する
      new_file=@expense.file.build(file: new_file, original_filename: new_file.original_filename)
      new_file.save!
    end
  end

  def redirection_path
    #  Hack リファクタする
    if params[:button] == 'repeat'
      @expense = Expense.new(use_date: params[:expense][:use_date])
      @default_expense_items = DefaultExpenseItem.all
      @file = @expense.file.new
      render template: "pages/expense_new"
    else
      redirect_to expense_list_path
    end
  end

  def set_redirection_data
    @expense = Expense.new(expense_param)
    @expense.default_id = params[:default_expense_item][:name]
    @default_expense_items = DefaultExpenseItem.all
    @file = @expense.file.new
  end
end
# rubocop:enable Metrics/ClassLength
