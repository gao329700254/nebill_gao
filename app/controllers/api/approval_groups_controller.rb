class Api::ApprovalGroupsController < Api::ApiController
  def index
    if params[:created_at].present?
      render json: ApprovalGroup.where(created_at: Time.zone.parse(params[:created_at]).all_day).as_json(include: :users)
    else
      render json: ApprovalGroup.all.as_json(include: :users)
    end
  end

  def show
    @approval_group = ApprovalGroup.find(params[:id])

    render json: @approval_group.as_json(include: { approval_group_users: { methods: :_destroy } })
  end

  def update
    @approval_group = ApprovalGroup.find(params[:id])

    if @approval_group.update(approval_group_params)
      render_action_model_flash_success_message @approval_group, :update
    else
      render_action_model_fail_message @approval_group, :update
    end
  end

  def create
    @approval_group = ApprovalGroup.new(approval_group_params)

    if @approval_group.save
      render_action_model_flash_success_message @approval_group, :create
    else
      render_action_model_fail_message @approval_group, :create
    end
  end

  def destroy
    @approval_group = ApprovalGroup.find(params[:id])

    if @approval_group.destroy
      render_action_model_flash_success_message @approval_group, :destroy
    else
      render_action_model_fail_message @approval_group, :destroy
    end
  end

  def approval_group_params
    params.require(:approval_group).permit(:name, :description, approval_group_users_attributes: [:id, :user_id, :_destroy])
  end
end
