module ProjectValidates
  extend ActiveSupport::Concern

  included do
    validates :key          , presence: true, uniqueness: { case_sensitive: false }
    validates :name         , presence: true
    validates :contract_on  , presence: true
    validates :amount       , numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }

    with_options if: :contracted? do |contracted|
      contracted.validates :contract_type       , presence: true
      contracted.validates :contractual_coverage, presence: true
      contracted.validates :start_on            , presence: true
      contracted.validates :end_on              , presence: true
      contracted.validates :amount              , presence: true
      contracted.validates :billing_company_name   , presence: true
      contracted.validates :billing_department_name, presence: true
      contracted.validates :billing_personnel_names, presence: true
      contracted.validates :billing_address        , presence: true
      contracted.validates :billing_zip_code       , presence: true
      contracted.validates :billing_memo           , presence: true
      contracted.validates :orderer_company_name   , presence: true
      contracted.validates :orderer_department_name, presence: true
      contracted.validates :orderer_personnel_names, presence: true
      contracted.validates :orderer_address        , presence: true
      contracted.validates :orderer_zip_code       , presence: true
      contracted.validates :orderer_memo           , presence: true
    end

    with_options unless: :contracted? do |un_contracted|
      un_contracted.validates :contract_type       , absence: true
      un_contracted.validates :is_using_ses        , absence: true
      un_contracted.validates :contractual_coverage, absence: true
      un_contracted.validates :start_on            , absence: true
      un_contracted.validates :end_on              , absence: true
      un_contracted.validates :amount              , absence: true
    end
  end
end
