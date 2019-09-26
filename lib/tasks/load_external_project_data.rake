require 'csv'

namespace :load_external_project_data do

  task run: :environment do
    ss_csv = CSV.read('project_spread_sheet.csv')
    valid_ss_projects, invalid_ss_projects = ss_csv.partition { |ss_project| valid_project_cd(ss_project[2])  =~ /\A\d{2}[a-zA-Z]\d{3}\z/ }
    show_invalid_ss_project(invalid_ss_projects)

    valid_ss_projects.each do |project|
      read_ss_project(project)
      revise_ss_data
      show_ss_data_unable_to_be_revised

      @nebill_project = Project.find_or_initialize_by(cd: @ss.cd)
      set_nebill_project_attrs
      @nebill_project.save!(validate: false)
    end

    puts "Notice: Load external project data successfully. The size of valid csv lines is #{valid_ss_projects.size}.\n\n"
  end

  private

  def read_ss_project(ss_project)
    @ss = ss_project_struct.new(ss_project[0], [ss_project[1], ss_project[9]], *ss_project[2..8])
  end

  def ss_project_struct
    @ss_project_struct ||= Struct.new(*%i(status memo cd name orderer_company_name amount contracted start_on end_on))
  end

  def valid_project_cd(cd)
    cd.to_s.delete(' ').tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  def show_invalid_ss_project(invalid_ss_projects)
    puts "Notice: skipped lines from spread sheet:"
    invalid_ss_projects.uniq.each { |ss_project| p ss_project }
    puts "\n"
  end

  def revise_ss_data
    @ss.cd = valid_project_cd(@ss.cd)
    revise_amount
    revise_date(@ss.start_on)
    revise_date(@ss.end_on)
  end

  def revise_amount
    return if @ss.amount.blank?
    return @ss.amount = nil if @ss.amount.in?(%w(- 時間精算))
    @ss.amount.slice!(0) if @ss.amount.start_with?('¥')
    @ss.amount.delete!(',')
  end

  def revise_date(date)
    return if date.blank?
    date.tr!('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
    date.chop! if date.end_with?('～')
    revise_specific_date(date)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def revise_specific_date(date)
    revised_date =
      case date
      when '2月、7月他'                   then '2016/2/1'
      when '二重採番（16K014使用）'         then '2016/4/30'
      when '8/31、9/30'                  then '2016/9/30'
      when '9/30,10/31'                  then '2016/10/31'
      when '4月～5月纏めて請求'             then '2017/5/1'
      when '11月30日'                     then '2017/11/30'
      when '10月1日'                      then '2018/10/1'
      when '2月28日'                      then '2019/2/28'
      when '保留', '/', '基本開発終了後設定' then ''
      else date
      end
    date.replace revised_date
  end

  # rubocop:disable Metrics/AbcSize
  def show_ss_data_unable_to_be_revised
    tasks = [
      { attr_name: 'status',                   attr_value: @ss.status,     condition: !(@ss.status.blank? || @ss.status.to_s == '*')           },
      { attr_name: 'amount',                   attr_value: @ss.amount,     condition: !(@ss.amount.blank? || @ss.amount =~ /\d+/)              },
      { attr_name: 'contracted',               attr_value: @ss.contracted, condition: !(@ss.contracted.blank? || @ss.contracted.in?(%w(済 -))) },
      { attr_name: 'start_on and contract_on', attr_value: @ss.start_on,   condition: !(@ss.start_on.blank? || valid_date?(@ss.start_on))      },
      { attr_name: 'end_on',                   attr_value: @ss.end_on,     condition: !(@ss.end_on.blank? || valid_date?(@ss.end_on))          },
    ]
    tasks.each { |t| show_ss_data(t[:attr_name], t[:attr_value]) if t[:condition] }
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity

  def valid_date?(date)
    date =~ %r(\A\d{4}\/\d{1,2}\/\d{1,2}\z)
  end

  def show_ss_data(attr_name, attr_value)
    puts "Notice: found [#{attr_name}: #{attr_value}] unable to be revised in below project of spread sheet"
    puts 'Skip inputting this attribute data to nebill'
    p @ss.to_a
    puts "\n"
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def set_nebill_project_attrs
    @nebill_project.status               = :finished if @ss.status == '*'
    @nebill_project.memo                 = @nebill_project.memo.blank? ? @ss.memo.join("\n") : [@nebill_project.memo, @ss.memo].join("\n")
    @nebill_project.name                 = @ss.name.to_s
    @nebill_project.orderer_company_name = @ss.orderer_company_name.to_s
    @nebill_project.amount               = @ss.amount if @ss.amount =~ /\d+/
    @nebill_project.contracted           = @ss.contracted.in?(%w(済 -)) ? true : false
    @nebill_project.start_on             = @nebill_project.contract_on = Date.parse(@ss.start_on) if valid_date?(@ss.start_on)
    @nebill_project.end_on               = Date.parse(@ss.end_on) if valid_date?(@ss.end_on)
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
