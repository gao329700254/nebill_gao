require 'highline/import'

email = ask('Input admin user email: ')
user=User.create(email: email, role: :admin)
admin=User.new(email: Faker::Internet.safe_email, name: Faker::Name.name, role: :admin)
admin.save!
user.update!(immediate_boss: admin.id)
