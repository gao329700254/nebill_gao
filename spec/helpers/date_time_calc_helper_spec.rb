require 'rails_helper'

RSpec.describe DateTimeCalcHelper do
  describe '#calc_date' do
    let(:args) do
      [
        { base_date: '2016-06-16', date_str: '15'                      , expect: '2016-07-15' },
        { base_date: '2016-06-21', date_str: '20th'                    , expect: '2016-07-20' },
        { base_date: '2016-06-21', date_str: '35th'                    , expect: '2016-07-05' },
        { base_date: '2016-06-21', date_str: 'end_of_month'            , expect: '2016-06-30' },
        { base_date: '2016-06-21', date_str: 'end_of_next_month'       , expect: '2016-07-31' },
        { base_date: '2016-06-21', date_str: 'end_of_month_after_next' , expect: '2016-08-31' },
        { base_date: '2016-06-21', date_str: '15th_of_next_month'      , expect: '2016-07-15' },
        { base_date: '2016-06-21', date_str: '15th_of_month_after_next', expect: '2016-08-15' },
      ]
    end
    it 'should return calc date' do
      aggregate_failures do
        args.each do |arg|
          expect(helper.calc_date(Date.parse(arg[:base_date]), arg[:date_str])).to eq Date.parse(arg[:expect])
        end
      end
    end
  end

  describe '#calc_date_of_next_this_day' do
    let(:args) do
      [
        { base_date: '2016-06-14', day: 15, expect: '2016-06-15' },
        { base_date: '2016-06-16', day: 15, expect: '2016-07-15' },
      ]
    end
    it 'should return next month expect day' do
      aggregate_failures do
        args.each do |arg|
          expect(helper.calc_date_of_next_this_day(Date.parse(arg[:base_date]), arg[:day])).to eq Date.parse(arg[:expect])
        end
      end
    end
  end

  describe '#calc_date_of_out_of_range_day' do
    let(:args) do
      [
        { base_date: '2016-06-15', day: 35, expect: '2016-07-05' },
        { base_date: '2016-07-15', day: 35, expect: '2016-08-04' },
      ]
    end
    it 'should return next month day' do
      aggregate_failures do
        args.each do |arg|
          expect(helper.calc_date_of_out_of_range_day(Date.parse(arg[:base_date]), arg[:day])).to eq Date.parse(arg[:expect])
        end
      end
    end
  end
end
