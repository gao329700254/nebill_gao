class Api::FilesController < Api::ApiController
  def approval_file_download
    @apprival_file = ApprovalFile.find(params[:files_id])
    file = @apprival_file.file

    file.download!(file.url) if Rails.env.production?
    send_file file.path, filename: @apprival_file.original_filename
  end
end
