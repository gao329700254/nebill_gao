json.partner do
  json.id           @partner.id
  json.name         @partner.name
  json.email        @partner.email
end
if @partner.client.present?
  json.client do
    json.id           @partner.client.id
    json.company_name @partner.client.company_name
    json.address      @partner.client.address
    json.zip_code     @partner.client.zip_code
    json.phone_number @partner.client.phone_number
    json.client_info  @partner.client.attributes.slice(*%w(company_name address zip_code phone_number)).values.join(', ')
  end
end
