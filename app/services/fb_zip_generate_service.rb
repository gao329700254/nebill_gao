class FbZipGenerateService < BaseService
  class InvalidRowError < StandardError; end
  CSV_HEADER = %i(date employee amount).freeze

  def initialize(transfer_informations_text)
    @transfer_informations_text = transfer_informations_text
  end

  def execute
    transfer_informations_by_date.map do |date, transfer_informations|
      next if date.blank?
      [date, build_csv_data(date, transfer_informations)]
    end.compact
  end

private

  def build_csv_data(date, transfer_informations)
    CSV.generate(encoding: 'SJIS', force_quotes: true) do |csv|
      total_amount = 0
      csv << [1, 21, 0, "", "カ) クオン", date, "0033", "ｼﾞﾔﾊﾟﾝﾈﾂﾄ", "002", "ｽｽﾞﾒ", "1", "3367098", ""]

      transfer_informations.each do |transfer_information, index|
        begin
          account = payee_accounts[transfer_information[:employee]].first
          fail unless transfer_information[:amount] =~ /\A[\d ,]*\z/
          amount  = transfer_information[:amount].delete(',').to_i

          total_amount += amount

          csv << build_row(amount, account)
        rescue
          raise InvalidRowError,
                "#{index + 1}行目でエラーが発生しました。=> '#{@transfer_informations_text.split("\n")[index]}'"
        end
      end

      csv << [8, transfer_informations.length, total_amount, '']
      csv << [9, '']
    end
  end

  def build_row(amount, account)
    [
      2,                           # データ区分（1) 「2」固定
      account[:bank_code],         # 銀行コード(4)
      account[:bank_name].strip,   # 銀行名(15)
      account[:filial_code],       # 支店コード(3）
      account[:filial_name].strip, # 支店名(15）
      '',                          # 手形交換所
      account[:inv_type],          # 預金種目(1)
      account[:inv_number],        # 口座番号(7)
      account[:employee],          # 受取人名(30)
      amount,                      # 金額（10)
      0,                           # 新規コード(1) ｢0」固定
      '',                          # 顧客コード１(10)
      '',                          # 顧客コード2(10)
      '',                          # 振込指定区分(1)
      '',                          # 識別表示(1)
      '',
    ]
  end

  def transfer_informations_by_date
    @transfer_informations_by_date ||= begin
      CSV.parse(@transfer_informations_text.to_s, headers: CSV_HEADER, col_sep: "\t")
         .each_with_index
         .group_by { |hash, _| hash[:date].strip }
    end
  end

  def payee_accounts
    @payee_accounts ||= PayeeAccount.all.group_by(&:employee)
  end
end
