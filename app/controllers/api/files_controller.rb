class Api::FilesController < Api::ApiController
  def approval_file_download
    @apprival_file = ApprovalFile.find(params[:files_id])
    file = @apprival_file.file

    file.download!(file.url) if ENV["FILE_STORAGE_TYPE"] == "fog"
    send_file file.path, filename: @apprival_file.original_filename
  end

  def expense_file_download
    @expense_file = ExpenseFile.find(params[:files_id])
    file = @expense_file.file

    file.download!(file.url) if ENV["FILE_STORAGE_TYPE"] == "fog"
    send_file file.path, filename: @expense_file.original_filename
  end
end
