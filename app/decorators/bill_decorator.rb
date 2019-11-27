class BillDecorator < Draper::Decorator
  delegate_all
  CONSUMPTION_TAX = 0.1

  def pdf_bill_no
    I18n.t('pdf.bill.number') + cd
  end

  def pdf_project_no
    I18n.t('pdf.pj_no') + project.cd
  end

  def pdf_billing_company_name
    [company_name, I18n.t('pdf.bill.onchu')].join
  end

  def pdf_subtotal_price
    subtotal_price.to_s(:delimited)
  end

  def pdf_price_include_tax
    price_include_tax.to_s(:delimited)
  end

  # TODO(maeda): 経費、精算分も加算必要
  # 内訳編集実装時に加算修正予定
  def pdf_total_price
    (subtotal_price + price_include_tax + expense).to_s(:delimited)
  end

  def pdf_total_price_yen
    pdf_total_price + '円'
  end

  def pdf_empty_rows
    Bill::MAX_DETAIL_COUNT - details.count
  end

private

  def subtotal_price
    details.sum(:amount)
  end

  def price_include_tax
    (subtotal_price * CONSUMPTION_TAX).floor
  end
end
