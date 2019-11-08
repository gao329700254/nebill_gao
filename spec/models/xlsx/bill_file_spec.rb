require 'rails_helper'

RSpec.describe Xlsx::BillFile do
  let(:project) { build(:project, start_on: '2016-01-01', end_on: '2017-01-01') }
  let(:bill) { build(:bill, amount: 110, project: project) }
  let(:template) { RubyXL::Parser.parse(File.join(Rails.root, 'spec', 'fixtures', 'sample.xlsx')) }
  let(:worksheet) { Xlsx::BillFile.new(bill, template).create[0] }

  describe '#create' do
    it "should replace with bill's value" do
      expect(worksheet[0][0].value).to  eq Time.zone.today.strftime("%Y/%m/%d")
      expect(worksheet[1][0].value).to  eq project.cd
      expect(worksheet[2][0].value).to  eq project.name
      expect(worksheet[3][0].value).to  eq "2016/01/01〜2017/01/01"
      expect(worksheet[4][0].value).to  eq bill.cd
      expect(worksheet[5][0].value).to  eq I18n.t("enumerize.defaults.payment_type.#{bill.payment_type}")
      expect(worksheet[6][0].value).to  eq bill.amount
      expect(worksheet[7][0].value).to  eq 110
      expect(worksheet[8][0].value).to  eq 11
      expect(worksheet[9][0].value).to  eq 121
      expect(worksheet[10][0].value).to eq 0
      expect(worksheet[11][0].value).to eq 0
      expect(worksheet[12][0].value).to eq project.billing_company_name || ''
    end
  end
end
