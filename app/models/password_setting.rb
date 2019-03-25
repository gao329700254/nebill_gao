class PasswordSetting
  include ActiveModel::Model

  attr_accessor :id, :password, :password_confirmation

  def persisted?
    true
  end
end
