require 'highline/import'

email = ask('Input admin user email: ')
User.create(email: email, role: :admin)
