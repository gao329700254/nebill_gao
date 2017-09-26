class Bills::PdfController < ApplicationController
  before_action :set_bill, only: [:download]

  def download
    render pdf:      pdf_file_name,
           template: "pdf/bill.html.slim",
           encoding: 'UTF-8'
  end

private

  def pdf_file_name
    [t('pdf.bill.title'), @bill.project.billing_company_name, @bill.cd].compact.join("_") + '.pdf'
  end

  def set_bill
    @bill = Bill.find(params[:bill_id]).decorate
  end
end
