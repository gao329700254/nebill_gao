require 'rails_helper'

RSpec.describe BillDetail, type: :model do
  describe '#detail_content' do
    let!(:bill) { create(:bill) }

    context 'amount is nil' do
      it do
        detail = bill.details.build(content: 'contente', amount: nil, display_order: 1)
        detail.valid?
        expect(detail.errors.messages).to be_empty
      end
    end

    context 'amount is present' do
      it do
        detail = bill.details.build(content: nil, amount: 1234, display_order: 1)
        detail.valid?
        expect(detail.errors.full_messages).to eq ['内訳を入力してください']
      end
    end
  end
end
