class Api::ProjectFilesController < Api::ApiController
  before_action :set_project, only: [:index, :create]

  def index
    @project_files = @project.files
    respond_to do |format|
      format.json
    end
  end

  def create
    @file = @project.files.build(file: params[:file])
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

private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
