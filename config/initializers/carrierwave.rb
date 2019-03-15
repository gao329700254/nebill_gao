if ENV["FILE_STORAGE_TYPE"] == "fog"
  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:                         'AWS',
      region:                           Rails.application.secrets.s3_region,
      aws_access_key_id:                Rails.application.secrets.s3_access_key_id,
      aws_secret_access_key:            Rails.application.secrets.s3_secret_access_key,
    }
    config.fog_directory = ENV["FILE_STORAGE_NAME"]
    config.fog_public    = false
  end
end
