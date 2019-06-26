class Api::FilesController < Api::ApiController
  def approval_file_download
    @approval_file = ApprovalFile.find(params[:files_id])
    file = @approval_file.file

    if ENV["FILE_STORAGE_TYPE"] == "fog"
      data = open(file.url)
      send_data data.read, filename: @approval_file.original_filename
    end
    send_file file.path, filename: @approval_file.original_filename
  end

  def expense_file_download
    @expense_file = ExpenseFile.find(params[:files_id])
    file = @expense_file.file

    if ENV["FILE_STORAGE_TYPE"] == "fog"
      data = open(file.url)
      send_data data.read, filename: @approval_file.original_filename
    end
    send_file file.path, filename: @expense_file.original_filename
  end

  def client_file_download
    @client_file = ClientFile.find(params[:files_id])
    file = @client_file.file

    if ENV["FILE_STORAGE_TYPE"] == "fog"
      data = open(file.url)
      send_data data.read, filename: @approval_file.original_filename
    end
    send_file file.path, filename: @client_file.original_filename
  end
end
