class Api::ProjectFilesController < Api::ApiController
  before_action :set_project, only: [:index, :create]
  before_action :set_project_file, only: [:show, :update, :destroy]

  def index
    @project_files = @project.files.where(file_type: 10)
    respond_to do |format|
      format.json
    end
  end

  def show
    file = @project_file.file
    file.download!(file.url) if ENV["FILE_STORAGE_TYPE"] == "fog"
    send_file file.path, filename: @project_file.original_filename
  end

  def create
    @file = @project.files.build(file: params[:file], original_filename: params[:file].original_filename)
    @file.save!

    render(
      json: {
        id: @project.id,
        message: I18n.t("action.upload.success", name: params[:file].original_filename),
      },
      status: :created,
    )
  rescue ActiveRecord::RecordInvalid
    render(
      json: {
        message: I18n.t("action.upload.fail", name: params[:file].original_filename),
        errors: { messages: @project.errors.messages, full_messages: @project.errors.full_messages },
      },
      status: :unprocessable_entity,
    )
  end

  def update
    @project_file.attributes = project_file_param
    @project_file.save!

    render_action_model_success_message(@project_file, :update)
  rescue ActiveRecord::RecordInvalid
    render_action_model_fail_message(@project_file, :update)
  end

  def destroy
    if @project_file.destroy
      render_action_model_success_message(@project_file, :destroy)
    else
      render_action_model_fail_message(@project_file, :destroy)
    end
  end

private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_project_file
    @project_file = ProjectFile.find(params[:id])
  end

  def project_file_param
    params.require(:project_file).permit(:file_group_id)
  end
end
