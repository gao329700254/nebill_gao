require 'highline/import'

email = ask('Input admin user email: ')
User.create(email: email, is_admin: true)
