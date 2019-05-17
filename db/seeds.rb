require 'highline/import'

email = ask('Input admin user email: ')
password =  STDIN.getpass('Input admin password: ')

random = SecureRandom.random_bytes(255)
admin=User.create!(email: Faker::Internet.safe_email, name: Faker::Name.name, role: :admin, password: random, password_confirmation: random)
admin.activate
user = User.create!(email: email, password: password, password_confirmation: password, role: :admin, default_allower: admin.id)
user.activate
