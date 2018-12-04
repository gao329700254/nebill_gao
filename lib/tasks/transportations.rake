namespace :transportations do
  desc "Save new type of transportations"
  task save: :environment do
    expenses = Expense.all
    expenses.each do |item|
      amount = if item.is_round_trip
                 item.amount/2
               else
                 item.amount
               end
      expense_tr = ExpenseTransportation.new(amount: amount, departure: item.depatture_location, arrival: item.arrival_location)
      expense_tr.save! if expense_tr.valid?(:amount)
    end
    puts "経費から経路を読み取りました。"
  end
end
