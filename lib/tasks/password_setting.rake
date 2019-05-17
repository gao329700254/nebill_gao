# usage
# bundle exec rake password_setting:send_email[username@example.com]
namespace :password_setting do
  desc "Send password setting email"
  task send_email: :environment do |task|
    arr_string = ARGV.first.slice(/(?<=#{task.name}).*/)

    # 配列っぽい文字列("[foo,bar]")が出来るので配列にする
    args = YAML.load(arr_string)

    @users = (args.first == 'all' ? User.all : User.where(email: args))

    @users.each(&:send_password_setting_email)
  end
end
