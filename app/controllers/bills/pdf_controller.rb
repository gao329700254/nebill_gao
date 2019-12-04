class Bills::PdfController < ApplicationController
  def download
    @bill    = Bill.find(params[:bill_id]).decorate
    @details = @bill.details.order(:display_order)

    render pdf:      pdf_file_name,
           template: "pdf/bill.html.slim",
           encoding: 'UTF-8',
           page_size: 'A4',
           show_as_html: params.key?('debug')
  end

private

  def pdf_file_name
    [t('pdf.bill.title'), @bill.project.billing_company_name, @bill.cd].compact.join("_")
  end
end
