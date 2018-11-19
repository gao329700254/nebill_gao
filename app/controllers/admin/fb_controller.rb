class Admin::FbController < ApplicationController
  before_action :fb_validates, only: [:fb_download_csv]

  def fb_download_csv
    Dir.mkdir('tmp/zip_target')
    payee_accounts = PayeeAccount.all
    csv_data = CSV.read(params[:file].path).sort_by { |row| [row[0].to_i, row[1].to_i] }
    csv_data.chunk { |l| l[0] }.each do |ch, rows|
      @data_records = []
      rows.each do |row|
        create_data_record(payee_accounts, row)
      end
      @total_list = rows.length
      @total_amount = rows.inject(0) { |a, e| a + e[2].delete('.').to_i }
      create_csv(ch)
    end
    download_zip(name: 'fbdate')
  ensure
    FileUtils.rm_rf('tmp/zip_target')
  end

private

  def fb_validates
    unless can? :manage, PayeeAccount
      flash[:error] = I18n.t("helpers.unauthorized")
      redirect_to root_path
      return
    end
    unless params[:file].present?
      flash[:error] = I18n.t("errors.format", attribute: "ファイル", message: I18n.t("errors.messages.unselected"))
      redirect_to admin_fb_date_output_path
      return
    end
  end

  def create_data_record(payee_accounts, row)
    el = payee_accounts.find { |e| e[:employee_id] == row[1].to_i }
    data_item = [2,
                 el[:bank_code],
                 el[:bank_name].strip,
                 el[:filial_code],
                 el[:filial_name].strip,
                 '',
                 el[:inv_type],
                 el[:inv_number],
                 el[:employee],
                 row[2],
                 0, '', '', '', '', '']
    @data_records.push data_item
  end

  def download_zip(name: 'date')
    target_files_path = "tmp/zip_target"
    zip_name = "#{name}.zip"
    output_zip_path = "tmp/#{zip_name}"
    target_files = []
    Dir.glob("#{target_files_path}/*.*").each do |i|
      target_files.push(File.basename(i))
    end
    Zip.unicode_names = true
    Zip::File.open(output_zip_path, Zip::File::CREATE) do |zipfile|
      target_files.each_with_index do |file|
        zipfile.add(file, "#{target_files_path}/#{file}")
      end
    end
    send_data(File.read(output_zip_path), filename: zip_name)
    File.delete(output_zip_path)
  end

  def create_csv(list_date)
    header_record = [1, 21, 0, "", "カ) クオン", list_date, "0033", "ｼﾞﾔﾊﾟﾝﾈﾂﾄ", "002", "ｽｽﾞﾒ", "1", "3367098", ""]
    trailer_record = [8, @total_list, @total_amount, '']
    end_record = [9, '']
    CSV.open("tmp/zip_target/全銀_" + list_date + ".csv", "w", force_quotes: true) do |file|
      file << header_record
      @data_records.each do |logs|
        file << logs
      end
      file << trailer_record
      file << end_record
    end
  end
end
