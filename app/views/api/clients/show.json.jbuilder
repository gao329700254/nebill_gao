json.id              @client.id
json.cd              @client.cd
json.company_name    @client.company_name
json.department_name @client.department_name
json.address         @client.address
json.zip_code        @client.zip_code
json.phone_number    @client.phone_number
json.memo            @client.memo
json.created_at      @client.created_at
json.updated_at      I18n.l(@client.updated_at.in_time_zone('Tokyo'))
json.whodunnit       '（' + @user.name + '）' if @user
