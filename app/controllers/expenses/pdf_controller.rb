class Expenses::PdfController < ApplicationController
  before_action :set_expense, only: [:download]

  def download
    render  "pdf/expense.html.slim", layout: false
  end

private

  def pdf_file_name
    [t('pdf.expense.title'), '1'].compact.join("_") + '.pdf'
  end

  def set_expense
    if params[:id] != '0'
      @expense_approval = ExpenseApproval.find(params[:id])
      expenses          = @expense_approval.expense.eager_load(:default).order(:use_date)
      @routing_expenses = expenses.merge(DefaultExpenseItem.where(is_routing: true))
      @other_expenses   = expenses.merge(DefaultExpenseItem.where(is_routing: false))
    else
      flash[:error] = I18n.t("errors.messages.expense_approval_is_empty")
      redirect_to(:back)
    end
  end
end
