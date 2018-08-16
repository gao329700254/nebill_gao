class Api::FilesController < Api::ApiController
  def approval_file_download
    @file = ApprovalFile.find(params[:files_id])
    
    @file.file.cache_stored_file!
    @file.file.retrieve_from_cache!(@file.file.cache_name)

    send_data @file.file.read, filename: @file.original_filename, length: @file.file.size
  end
end
