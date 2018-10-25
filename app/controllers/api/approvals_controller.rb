# rubocop:disable Metrics/ClassLength
class Api::ApprovalsController < Api::ApiController
  def index
    if can?(:allread, Approval)
      @approvals = Approval.all.includes([:created_user, :users, :approval_users])
    else
      @approvals = Approval.all.includes([:created_user, :users, :approval_users])
                           .references(:approval_users).where('created_user_id = ? OR approval_users.user_id = ?', current_user.id, current_user.id)
    end
    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end

  def create
    default_allower_is_nill? && return
    if !params[:user_id].empty?
      @approval = Approval.new(approval_param)
      @approval.created_user_id = @current_user.id
      if @approval.save!

        file_create
        approval_user_save
      end
    else
      flash[:error] = I18n.t("errors.messages.default_allower_is_empty")
      @approval = Approval.new(approval_param)
      render template: "pages/approval_new"
    end

  rescue ActiveRecord::RecordInvalid
    flash[:error] = "#{I18n.t('action.create.fail', model: I18n.t("activerecord.models.#{@approval.class.name.underscore}"))}"\
                              " \n #{@approval.errors.full_messages.join('<br>')}"
    redirect_to approval_new_path
  end

  # rubocop:disable Metrics/AbcSize
  def search_result
    @approvals = if params[:created_at].present? && can?(:allread, Approval)
                   Approval.where_created_at(params[:created_at]).includes(:created_user)
                 elsif params[:created_at].present?
                   Approval.where_created_at(params[:created_at]).includes([:created_user, :users, :approval_users])
                           .references(:approval_users).where('created_user_id = ? OR approval_users.user_id = ?', current_user.id, current_user.id)
                 elsif can?(:allread, Approval)
                   Approval.all.includes([:created_user, :users, :approval_users])
                 else
                   Approval.all.includes([:created_user, :users, :approval_users])
                           .references(:approval_users).where('created_user_id = ? OR approval_users.user_id = ?', current_user.id, current_user.id)
                 end

    render 'index', formats: 'json', handlers: 'jbuilder', status: :ok
  end
  # rubocop:enable Metrics/AbcSize

  def update
    @approval = Approval.find(params[:id])
    if @approval.status == 40
      flash[:error] = I18n.t("errors.messages.wrong_status")
      redirect_to approval_show_path(params[:id]) && return
    end
    @current_user_approval = @approval.approval_users.includes(:user).find_by(user_id: @current_user.id)
    update_button_type
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "#{I18n.t('action.update.fail', model: I18n.t('activerecord.models.approval'))}"\
                    " \n #{@approval.errors.full_messages.join('<br>')}"\
                    " \n #{@current_user_approval.errors.full_messages.join('<br>')}"

    redirect_to(:back)
  end

private

  def approval_param
    params.require(:approval).permit(
      :name,
      :category,
      :notes,
    )
  end

  def file_param
    params.require(:approval).permit(
      files_attributes: [:id, :file, :_destroy],
    )
  end

  def approval_user_save
    @approval_user = @approval.approval_users.build(user_id: params[:user_id])
    if @approval_user.save!
      ApprovalMailer.assignment_user(user: @approval_user.user, approval: @approval).deliver_now
      Chatwork::Approval.new(approval: @approval, to_user: @approval_user.user).notify_assigned
      action_model_flash_success_message(@approval, :create)
      redirect_to approval_show_path(approval_id: @approval.id)
    end
  end

  def params_file?
    params[:approval][:files_attributes]
  end

  def user_param
    params.require(:user).permit(:id)
  end

  def approval_user_param
    params.require(:approval_user).permit(:comment)
  end

  def default_allower_is_nill?
    return unless @current_user.default_allower.blank?
    redirect_to approval_new_path, flash: { error:  I18n.t("errors.messages.default_allower_is_nill") }
  end

  def file_create
    if params_file?
      file_param[:files_attributes].each do |file|
        file = file[1][:file]
        if file
          file=@approval.files.build(file: file, original_filename: file.original_filename)
          file.save!
        end
      end
    end
  end

  def update_button_type
    case params[:button]
    when 'invalid'
      invalid
    when 'permission'
      permission
    when 'disconfirm'
      disconfirm
    when 'reassignment'
      reassignment
    when 'edit'
      edit
    end
  end

  def invalid
    @approval.status = 40
    @approval.save!
    action_model_flash_success_message(@approval, :invalid)
    redirect_to approval_show_path(params[:id])
  end

  def permission
    @current_user_approval.update!(status: 20, comment: approval_user_param[:comment])

    @approval_users = @approval.approval_users.includes(:user)

    if @approval_users.any? { |approval_user| approval_user.status == 20 }
      @approval.update!(status: 20)
      ApprovalMailer.permission_approval(user: @approval.created_user, approval: @approval).deliver_now
      Chatwork::Approval.new(approval: @approval, to_user: @approval.created_user).notify_permited
    elsif @approval_users.none? { |approval_user| approval_user.status == 30 }
      @approval.update!(status: 10)
    end

    action_model_flash_success_message(@approval, :permission)
    redirect_to approval_list_path
  end

  def disconfirm
    @current_user_approval.update!(status: 30, comment: approval_user_param[:comment])
    @approval.update!(status: 30)
    ApprovalMailer.disconfirm_approval(user: @approval.created_user, approval: @approval).deliver_now
    action_model_flash_success_message(@approval, :disconfirm)
    redirect_to approval_list_path
  end

  # rubocop:disable Metrics/AbcSize
  def reassignment
    if !user_param[:id].empty?
      @approval_user = @approval.approval_users.build(user_id: user_param[:id])
      if @approval_user.user.name.present?
        if @current_user_approval.present?
          @current_user_approval.update!(status: 40)
        end
        @approval_user.save!
        @approval.status == 20 && @approval.update!(status: 10)
        ApprovalMailer.assignment_user(user: @approval_user.user, approval: @approval).deliver_now
        Chatwork::Approval.new(approval: @approval, to_user: @approval_user.user).notify_assigned

        model_flash_success_message(:reassignment)
      else
        flash[:error] = I18n.t("action.reassignment.fail")
      end
    else
      flash[:error] = I18n.t("action.reassignment.fail")
    end
    redirect_to approval_show_path(params[:id])
  end
  # rubocop:enable Metrics/AbcSize

  def edit
    if @approval.status != 30
      flash[:error] = I18n.t("action.update.fail", model: I18n.t("activerecord.models.approval"))
      redirect_to approval_show_path(params[:id])
      return
    end
    @approval.update(approval_param)

    params_file? && edit_file

    if @approval.update!(status: 10)
      @approval.users.each do |user|
        ApprovalMailer.update_approval(user: user, approval: @approval).deliver_now
      end
      action_model_flash_success_message(@approval, :update)
    end

    redirect_to approval_show_path(params[:id])
  end

  def edit_file
    file_param[:files_attributes].each do |file|
      new_file = file.second[:file]
      if file.second[:id].present?
        uploaded_file = @approval.files.find(file[1][:id])
        if file.second[:_destroy].present?
          # ファイルを削除する
          uploaded_file.destroy!
        elsif file.second[:file].present?
          # ファイルを更新する
          uploaded_file.update!(file: new_file, original_filename: new_file.original_filename)
        end
      elsif file.second[:_destroy].blank?
        # ファイルを作成する
        new_file=@approval.files.build(file: new_file, original_filename: new_file.original_filename)
        new_file.save!
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
