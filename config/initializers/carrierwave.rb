if Rails.env.production?
  CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
  CarrierWave.configure do |config|
    config.root = Rails.root.join('tmp')
    config.fog_provider = 'fog/google'
    config.fog_credentials = {
      provider:                         'Google',
      google_storage_access_key_id:     Rails.application.secrets.google_storage_access_key_id,
      google_storage_secret_access_key: Rails.application.secrets.google_storage_secret_access_key,
    }
    config.fog_directory = 'nebill-production'
  end
end
