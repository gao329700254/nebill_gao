json.amount                   @project.amount
json.billing_address          @project.billing_address
json.billing_company_name     @project.billing_company_name
json.billing_department_name  @project.billing_department_name
json.billing_memo             @project.billing_memo
json.billing_personnel_names  @project.billing_personnel_names
json.billing_phone_number     @project.billing_phone_number
json.billing_zip_code         @project.billing_zip_code
json.cd                       @project.cd
json.contract_on              @project.contract_on
json.contract_type            @project.contract_type
json.contracted               @project.contracted
json.created_at               @project.created_at
json.end_on                   @project.end_on
json.estimated_amount         @project.estimated_amount
json.group_id                 @project.group_id
json.id                       @project.id
json.is_regular_contract      @project.is_regular_contract
json.is_using_ses             @project.is_using_ses
json.leader_id                @project.leader_id
json.memo                     @project.memo
json.name                     @project.name
json.orderer_address          @project.orderer_address
json.orderer_company_name     @project.orderer_company_name
json.orderer_department_name  @project.orderer_department_name
json.orderer_memo             @project.orderer_memo
json.orderer_personnel_names  @project.orderer_personnel_names
json.orderer_phone_number     @project.orderer_phone_number
json.orderer_zip_code         @project.orderer_zip_code
json.payment_type             @project.payment_type
json.start_on                 @project.start_on
json.status                   @project.status
json.unprocessed              @project.unprocessed
json.updated_at               @project.updated_at
if @project.files
  @project.files.each do |file|
    json.files     file if file.file_type == 20
  end
end
