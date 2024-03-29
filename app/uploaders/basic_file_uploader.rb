class BasicFileUploader < CarrierWave::Uploader::Base
  if ENV["FILE_STORAGE_TYPE"] == "fog"
    storage :fog
  else
    storage :file
  end

  def store_dir
    if ENV["FILE_STORAGE_TYPE"] == "fog"
      File.join(
        model.class.to_s.underscore,
        mounted_as.to_s,
        model.id.to_s,
      )
    else
      File.join(
        'uploads',
        Rails.env.to_s,
        model.class.to_s.underscore,
        mounted_as.to_s,
        model.id.to_s,
      )
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    return unless original_filename
    @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
    "#{@name}.#{file.extension}"
  end

  process :set_metadata

  def set_metadata
    model.original_filename = File.basename(current_path)
  end
end
