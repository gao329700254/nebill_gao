class DestinationInformation
  attr_reader :company_name, :department_name, :personnel_names, :address, :zip_code, :phone_number, :memo

  # rubocop:disable Metrics/ParameterLists
  def initialize(company_name, department_name, personnel_names, address, zip_code, phone_number, memo)
    @company_name    = company_name
    @department_name = department_name
    @personnel_names = personnel_names
    @address         = address
    @zip_code        = zip_code
    @phone_number    = phone_number
    @memo            = memo
  end
  # rubocop:enable Metrics/ParameterLists
end
