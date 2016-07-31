module DateTimeCalcHelper
  # rubocop:disable Metrics/CyclomaticComplexity
  def calc_date(base_date, date_str)
    case date_str
    when /\A([0-9]+)(th)?\z/
      day = Regexp.last_match(1).to_i
      if day <= base_date.end_of_month.day
        calc_date_of_next_this_day(base_date, day)
      else
        calc_date_of_out_of_range_day(base_date, day)
      end
    when /\A([0-9]+)(th)?_of_next_month\z/
      Date.parse base_date.since(1.month).strftime("%Y-%m-#{Regexp.last_match(1).to_i}")
    when /\A([0-9]+)(th)?_of_month_after_next\z/
      Date.parse base_date.since(2.months).strftime("%Y-%m-#{Regexp.last_match(1).to_i}")
    when /\Aend_of_month\z/
      base_date.end_of_month.to_date
    when /\Aend_of_next_month\z/
      base_date.since(1.month).end_of_month.to_date
    when /\Aend_of_month_after_next\z/
      base_date.since(2.months).end_of_month.to_date
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def calc_date_of_next_this_day(base_date, day)
    if base_date.day <= day
      Date.parse base_date.strftime("%Y-%m-#{day}")
    else
      Date.parse base_date.since(1.month).strftime("%Y-%m-#{day}")
    end
  end

  def calc_date_of_out_of_range_day(base_date, day)
    gap = day - base_date.end_of_month.day
    base_date.end_of_month.since(gap.days).to_date
  end
end
