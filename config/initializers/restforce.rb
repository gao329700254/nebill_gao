Restforce.configure do |conf|
  conf.username       = Rails.application.secrets.sf_username
  conf.password       = Rails.application.secrets.sf_password
  conf.security_token = Rails.application.secrets.sf_security_token
  conf.client_id      = Rails.application.secrets.sf_client_id
  conf.client_secret  = Rails.application.secrets.sf_client_secret
  conf.instance_url   = Rails.application.secrets.sf_instance_url
  conf.host           = Rails.application.secrets.sf_host
  conf.api_version    = Rails.application.secrets.sf_api_version
end
Restforce.log = true
