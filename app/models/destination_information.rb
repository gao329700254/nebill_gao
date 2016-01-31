class DestinationInformation
  attr_reader :company_name, :department_name, :personnel_names, :address, :zip_code, :memo

  # rubocop:disable Metrics/ParameterLists
  def initialize(company_name, department_name, personnel_names, address, zip_code, memo)
    @company_name    = company_name
    @department_name = department_name
    @personnel_names = personnel_names
    @address         = address
    @zip_code        = zip_code
    @memo            = memo
  end
  # rubocop:enable Metrics/ParameterLists
end
