class Expenses::CsvController < ApplicationController
  def download_csv
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
    format_csv(@expenses)
  end

  def header
    @header = [
      t('activerecord.attributes.expense_approval.id'),
      t('activerecord.attributes.expense_approval.status'),
      t('page.expense_csv.approval_date'),
      t('page.expense_csv.approval_user'),
      t('activerecord.attributes.expense_approval_user.name'),
      t('page.expense_csv.date'),
      t('page.expense_csv.category_name'),
      t('activerecord.attributes.expense.amount'),
      t('activerecord.attributes.expense.depatture_location'),
      t('activerecord.attributes.expense.arrival_location'),
      t('page.expense_csv.receipt'),
      t('activerecord.attributes.expense_approval.notes'),
      t('activerecord.attributes.expense.payment_type'),
    ]
  end

private

  def format_csv(expenses)
    respond_to do |format|
      format.html
      format.csv do
        send_data expenses.to_csv(header),
                  type: 'text/csv; charset=utf-8',
                  filename: I18n.t("page.expense_csv.csvname") + @st + '_' + @end + '.csv'
      end
    end
  end
end
