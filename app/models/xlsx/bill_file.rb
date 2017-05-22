require 'rubyXL'

module Xlsx
  class BillFile
    CONSUMPTION_TAX = 0.08

    def initialize(bill, template)
      @bill = bill
      @project = @bill.project
      @template = template
    end

    def create
      workbook = @template
      edit_workbook(workbook)
      workbook
    end

  private

    def edit_workbook(workbook)
      workbook.worksheets.each do |worksheet|
        worksheet.each do |row|
          row && row.cells.each do |cell|
            if cell && cell.value
              target = cell.value.to_s.slice!(/\[(.+?)\]/)
              edit_cell(cell, target)
            end
          end
        end
      end
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def edit_cell(cell, target)
      case target
      when "[Time.zone.today]"         then replace!(cell, target, date_format(Time.zone.today))
      when "[project_cd]"              then replace!(cell, target, @project.cd)
      when "[project_name]"            then replace!(cell, target, @project.name)
      when "[project_period]"          then replace!(cell, target, project_period)
      when "[bill_cd]"                 then replace!(cell, target, @bill.cd)
      when "[bill_payment_type]"       then replace!(cell, target, I18n.t("enumerize.defaults.payment_type.#{@bill.payment_type}"))
      when "[bill_amount]"             then replace!(cell, target, @bill.amount)
      when "[subtotal]"                then replace!(cell, target, subtotal)
      when "[tax]"                     then replace!(cell, target, tax)
      when "[total]"                   then replace!(cell, target, total)
      # TODO(ito): Change under two conditions when the function of computing man-hours is added
      when "[excess]"                  then replace!(cell, target, 0)
      when "[transportation_expenses]" then replace!(cell, target, 0)
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def replace!(cell, target, value)
      replace_word = value.is_a?(Integer) ? cell.value.gsub(target, value.to_s).to_i : cell.value.gsub(target, value)
      cell.change_contents(replace_word, cell.formula)
    end

    def date_format(date)
      date.strftime("%Y/%m/%d")
    end

    def project_period
      if @project.start_on || @project.end_on
        [date_format(@project.start_on), date_format(@project.end_on)].compact.join("〜")
      else
        ""
      end
    end

    def subtotal
      # TODO(sito): Change when the function of computing man-hours is added
      @bill.amount
    end

    def tax
      (subtotal * CONSUMPTION_TAX).floor
    end

    def total
      # TODO(sito): Change when the function of computing man-hours is added
      subtotal + tax
    end
  end
end
