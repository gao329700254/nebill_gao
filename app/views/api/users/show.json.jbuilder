json.id              @user.id
json.name            @user.name
json.email           @user.email
json.role            @user.role
json.default_allower @user.default_allower
json.created_at      @user.created_at
json.updated_at      I18n.l(@user.updated_at.in_time_zone('Tokyo'))
