# == Schema Information
# Schema version: 20181107015035
#
# Table name: payee_accounts
#
#  id          :integer          not null, primary key
#  employee_id :integer          not null
#  bank_code   :integer
#  filial_code :integer
#  inv_type    :integer
#  inv_number  :string(15)
#  employee    :string(200)
#  bank_name   :string
#  filial_name :string
#

class PayeeAccount < ActiveRecord::Base
end
