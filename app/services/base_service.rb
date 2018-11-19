class BaseService
  include ActiveModel::Model

  def initialize(params:)
    @params = params
  end

  def execute
    false
  end
end
