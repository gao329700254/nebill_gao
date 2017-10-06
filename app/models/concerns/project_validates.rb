module ProjectValidates
  extend ActiveSupport::Concern

  included do
    validates :cd               , presence: true, uniqueness: { case_sensitive: false }
    validates :name             , presence: true
    validates :amount           , numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }
    validates :estimated_amount , numericality: { only_integer: true, greater_than_or_equal_to: 0, allow_nil: true }

    with_options if: :contracted? do |contracted|
      contracted.validates :contract_on         , presence: true
      contracted.validates :contract_type       , presence: true
      contracted.validates :status              , presence: true
      contracted.validates :start_on            , presence: true
      contracted.validates :end_on              , presence: true
      contracted.validates :amount              , presence: true
      contracted.validates :payment_type        , presence: true
      contracted.validates :billing_company_name   , presence: true
      contracted.validates :billing_department_name, presence: true
      contracted.validates :billing_personnel_names, presence: true
      contracted.validates :billing_address        , presence: true
      contracted.validates :billing_zip_code       , presence: true
      contracted.validates :billing_phone_number   , presence: true
      contracted.validates :orderer_company_name   , presence: true
      contracted.validates :orderer_department_name, presence: true
      contracted.validates :orderer_personnel_names, presence: true
      contracted.validates :orderer_address        , presence: true
      contracted.validates :orderer_zip_code       , presence: true
      contracted.validates :orderer_phone_number   , presence: true
    end

    with_options unless: :contracted? do |un_contracted|
      un_contracted.validates :contract_on         , absence: true
      un_contracted.validates :contract_type       , absence: true
      un_contracted.validates :status              , absence: true
      un_contracted.validates :estimated_amount    , absence: true
      un_contracted.validates :is_using_ses        , absence: true
      un_contracted.validates :start_on            , absence: true
      un_contracted.validates :end_on              , absence: true
      un_contracted.validates :amount              , absence: true
      un_contracted.validates :payment_type        , absence: true
    end

    validate :can_not_change_from_contracted_to_uncontracted, on: :update
  end

private

  def can_not_change_from_contracted_to_uncontracted
    errors.add(:contracted, I18n.t('errors.messages.change', value: false)) if !contracted && contracted_was
  end
end
