class Api::FilesController < Api::ApiController
  def approval_file_download
    file_download(ApprovalFile.find(params[:files_id]))
  end

  def expense_file_download
    file_download(ExpenseFile.find(params[:files_id]))
  end

  def client_file_download
    file_download(ClientFile.find(params[:files_id]))
  end

private

  def file_download(file_model)
    file = file_model.file

    if ENV["FILE_STORAGE_TYPE"] == "fog"
      data = open(file.url)
      send_data data.read, filename: file_model.original_filename
    else
      send_file file.path, filename: file_model.original_filename
    end
  end
end
