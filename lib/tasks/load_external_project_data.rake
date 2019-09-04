require 'csv'

namespace :load_external_project_data do

  task run: :environment do
    spread_sheet_csv = CSV.read('project_spread_sheet.csv')
    spread_sheet_csv.delete_if { |line| unvalid_line?(line) }
    show_unvalid_lines(spread_sheet_csv)
    show_valid_line_size(spread_sheet_csv)

    spread_sheet_csv.each do |ss_project|
      nebill_project = Project.find_or_initialize_by(cd: valid_project_cd(ss_project))
      set_project_attributes(nebill_project, ss_project)
      nebill_project.save!(validate: false)
    end

    puts "Notice: load external project data successfully\n\n"
  end

  private

  def unvalid_line?(line)
    !(valid_project_cd(line) =~ /\A\d{2}[a-zA-Z]\d{3}\z/)
  end

  def show_unvalid_lines(revised_project_csv)
    all_project = CSV.read('project_spread_sheet.csv')
    puts "\nNotice: skipped lines from spread sheet:"
    (all_project - revised_project_csv).uniq.each { |line| p line }
    puts "\n"
  end

  def show_valid_line_size(revised_project_csv)
    puts "Notice: the size of valid csv lines is #{revised_project_csv.size} "
    puts "\n"
  end

  def valid_project_cd(line)
    project_cd = line[2]
    full_to_half(remove_space(project_cd)) if project_cd.present?
  end

  def remove_space(str)
    str.delete(' ')
  end

  def full_to_half(str)
    str.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  def set_project_attributes(nebill_project, ss_project)
    set_status(nebill_project, ss_project)
    set_memo(nebill_project, ss_project)
    set_name(nebill_project, ss_project)
    set_orderer_company_name(nebill_project, ss_project)
    set_amount(nebill_project, ss_project)
    set_contracted(nebill_project, ss_project)
    set_start_on_and_contract_on(nebill_project, ss_project)
    set_end_on(nebill_project, ss_project)
  end

  def set_status(nebill_project, ss_project)
    status = ss_project[0]
    if status == '*'
      nebill_project.status = :finished
    elsif status.present?
      show_data_unable_to_be_revised('finished status data', status, ss_project)
    end
  end

  def set_memo(nebill_project, ss_project)
    if nebill_project.memo.present?
      nebill_project.memo += ("\n" + ss_project[1].to_s)
    else
      nebill_project.memo = ss_project[1].to_s
    end
    nebill_project.memo += ("\n" + ss_project[9].to_s)
  end

  def set_name(nebill_project, ss_project)
    nebill_project.name = ss_project[3].to_s
  end

  def set_orderer_company_name(nebill_project, ss_project)
    nebill_project.orderer_company_name = ss_project[4]
  end

  def set_amount(nebill_project, ss_project)
    amount = ss_project[5]
    return if unvalid_amount?(amount)

    amount.slice!(0) if amount.start_with?('¥')
    amount.delete!(',')

    if amount =~ /\d+/
      nebill_project.amount = amount
    elsif amount.present?
      show_data_unable_to_be_revised('amount', amount, ss_project)
    end
  end

  def unvalid_amount?(amount)
    return true if amount.blank?
    case amount
    when '-', '時間精算' then true
    else false
    end
  end

  def set_contracted(nebill_project, ss_project)
    contracted = ss_project[6]
    nebill_project.contracted =
      if contracted == '済' || contracted == '-' then true
      elsif contracted.present?
        show_data_unable_to_be_revised('contracted', contracted, ss_project)
      else
        false
      end
  end

  def set_start_on_and_contract_on(nebill_project, ss_project)
    start_on = ss_project[7]
    return if unvalid_date?(start_on)

    start_on = formatted_date(start_on)
    if start_on =~ %r(\A\d{4}\/\d{1,2}\/\d{1,2}\z)
      nebill_project.start_on = nebill_project.contract_on = Date.parse(start_on)
    else
      show_data_unable_to_be_revised('start_on and contract_on', start_on, ss_project)
    end
  end

  def set_end_on(nebill_project, ss_project)
    end_on = ss_project[8]
    return if unvalid_date?(end_on)

    end_on = formatted_date(end_on)
    if end_on =~ %r(\A\d{4}\/\d{1,2}\/\d{1,2}\z)
      nebill_project.end_on = Date.parse(end_on)
    else
      show_data_unable_to_be_revised('end_on', end_on, ss_project)
    end
  end

  def unvalid_date?(date)
    return true if date.blank?
    case date
    when '保留', '/', '基本開発終了後設定' then true
    else false
    end
  end

  def formatted_date(date)
    date = full_to_half(date)
    date.chop! if date.end_with?('～')
    revised_specific_date(date)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def revised_specific_date(date)
    case date
    when '2月、7月他'             then '2016/2/1'
    when '二重採番（16K014使用）'   then '2016/4/30'
    when '8/31、9/30'            then '2016/9/30'
    when '9/30,10/31'            then '2016/10/31'
    when '4月～5月纏めて請求'       then '2017/5/1'
    when '11月30日'               then '2017/11/30'
    when '10月1日'                then '2018/10/1'
    when '2月28日'                then '2019/2/28'
    else date
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def show_data_unable_to_be_revised(attr_name, attr_value, ss_project)
    puts "Notice: found [#{attr_name}: #{attr_value}] unable to be revised in below project of spread sheet"
    puts 'Skip inputting this attribute data to nebill'
    p ss_project
    puts "\n"
  end
end
