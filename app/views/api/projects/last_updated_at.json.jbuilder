json.updated_at I18n.l(@latest_version.created_at.in_time_zone('Tokyo'))
json.whodunnit  @user ? '（' + @user.name + '）' : ''
