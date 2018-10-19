require 'highline/import'

email = ask('Input admin user email: ')
admin=User.new(email: Faker::Internet.safe_email, name: Faker::Name.name, role: :admin)
admin.save!
User.create(email: email, role: :admin, default_allower: admin.id)
