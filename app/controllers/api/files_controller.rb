class Api::FilesController < Api::ApiController
  def approval_file_download
    @file = ApprovalFile.find(params[:files_id].to_i)
    file_download
  end

private

  def file_download
    filepath = @file.file.current_path
    stat = File.stat(filepath)
    send_file(filepath, filename: @file.original_filename, length: stat.size)
  end
end
