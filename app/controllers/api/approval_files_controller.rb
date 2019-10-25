class Api::ApprovalFilesController < ApplicationController
  def create
    @approval = Approval.new

    approval_file_params.each do |file|
      @approval.files.build(file: file).file.cache!
    end

    render json: { approval_files: @approval.files.as_json(only: [:original_filename], methods:  [:file_cache]) }
  end

private

  def approval_file_params
    params.require(:approval_files).require(:files)
  end
end
