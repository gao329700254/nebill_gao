class ApprovalIndividualGroupSwitch
  ApprovalUserStatus = Struct.new(:name, :status, :comment)

  def initialize(approval, current_user)
    @approval = approval
    @current_user = current_user

    if @approval.approvaler_type.group?
      @approval.approval_group.users.each do |record|
        @approval.approval_users.build(user: record) if @approval.approval_users.find_by(user: record).blank?
      end
    end
  end

  def users
    users = @approval.approvaler_type.group? ? @approval.approval_group.users : @approval.users
    unable_user = users.pluck :id
    unable_user << @approval.created_user_id

    User.where.not(id: unable_user).without_role('outer')
  end

  def new_user
    User.new
  end

  def current_user_approval
    if @approval.approvaler_type.user?
      @approval.approval_users.find_by(user_id: @current_user.id)
    elsif @approval.approvaler_type.group?
      @approval.approval_users.find { |i| i.user_id == @current_user.id }
    end
  end

  def approval_users
    if @approval.approvaler_type.group?
      @approval.approval_group.users.map do |record|
        approval_user = @approval.approval_users.find_by(user: record)
        if approval_user.present?
          ApprovalUserStatus.new(approval_user.user.name, approval_user.status_text, approval_user.comment)
        else
          ApprovalUserStatus.new(record.name, Approval.status.default_value.text, '')
        end
      end
    elsif @approval.approvaler_type.user?
      @approval.approval_users.map do |approval_user|
        ApprovalUserStatus.new(approval_user.user.name, approval_user.status_text, approval_user.comment)
      end
    end
  end

  def approval_files
    @approval.files
  end
end
