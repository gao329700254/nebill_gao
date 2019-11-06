namespace :bill do
  desc "destroy all bills existing"
  task destroy_previous_bills: :environment do
    puts "start deleting all bills"
    puts "now registed #{Bill.count} bills before deleting"
    Bill.destroy_all
    puts "finish deleting all bills"
    puts "now registed #{Bill.count} bills after deleting"
  end
end
