class BillDecorator < Draper::Decorator
  delegate_all
  CONSUMPTION_TAX = 0.08

  def pdf_bill_no
    I18n.t('pdf.bill.number') + cd
  end

  def pdf_project_no
    I18n.t('pdf.pj_no') + project.cd
  end

  def pdf_billing_company_name
    [project.billing_company_name, I18n.t('pdf.bill.onchu')].compact.join
  end

  def pdf_price_include_tax
    price_include_tax.to_s(:delimited)
  end

  def pdf_total_price
    (amount + price_include_tax).to_s(:delimited)
  end

  def pdf_total_price_yen
    pdf_total_price + '円'
  end

  def pdf_period
    formatted_start_on = l(project.start_on, format: :default) if project.start_on
    formatted_end_on = l(project.end_on, format: :default) if project.end_on
    I18n.t('pdf.period') + [formatted_start_on, formatted_end_on].compact.join("〜")
  end

private

  def price_include_tax
    (amount * CONSUMPTION_TAX).floor
  end
end
