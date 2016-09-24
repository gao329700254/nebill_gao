class Bills::XlsxController < ApplicationController
  before_action :set_bill, only: [:download]

  def download
    send_xlsx_data(Xlsx::BillFile.new(@bill, template).create.stream.string, xlsx_file_name)
  end

private

  def send_xlsx_data(data, filename)
    filename = ERB::Util.url_encode(filename) if msie?
    send_data(data, filename: filename)
  end

  def msie?
    (/MSIE/ =~ request.user_agent) || (/Trident/ =~ request.user_agent)
  end

  def template
    RubyXL::Parser.parse(File.join(Rails.root, 'app', 'assets', 'xlsx', 'bill.xlsx'))
  end

  def xlsx_file_name
    ['請求書', @bill.project.billing_company_name, @bill.key].compact.join("_") + '.xlsx'
  end

  def set_bill
    @bill = Bill.find(params[:bill_id])
  end
end
