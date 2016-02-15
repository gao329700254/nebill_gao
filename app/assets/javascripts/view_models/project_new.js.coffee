$ ->
  window.progress = new Vue
    el: '#project_new'
    data:
      project_init:
        contracted: false
        key: ''
        name: ''
        contract_on: ''
        contract_type: 'lump_sum'
        start_on: ''
        end_on: ''
        amount: ''
        orderer_company_name: ''
        orderer_department_name: ''
        orderer_personnel_names_str: ''
        orderer_address: ''
        orderer_zip_code: ''
        orderer_memo: ''
        billing_company_name: ''
        billing_department_name: ''
        billing_personnel_names_str: ''
        billing_address: ''
        billing_zip_code: ''
        billing_memo: ''
      project: undefined
    created: ->
      @project = $.extend(true, {}, @project_init)
    computed:
      orderer_personnel_names: -> @project.orderer_personnel_names_str.split(/\s*,\s*|\s*、\s*/)
      billing_personnel_names: -> @project.billing_personnel_names_str.split(/\s*,\s*|\s*、\s*/)
    methods:
      copy: ->
        @project.billing_company_name        = @project.orderer_company_name
        @project.billing_department_name     = @project.orderer_department_name
        @project.billing_personnel_names_str = @project.orderer_personnel_names_str
        @project.billing_address             = @project.orderer_address
        @project.billing_zip_code            = @project.orderer_zip_code
      submit: ->
        try
          submit = $('.project_new__form__submit_btn')
          submit.prop('disabled', true)
          postData = undefined
          if @project.contracted
            postData =
              project:
                contracted:    @project.contracted
                key:           @project.key
                name:          @project.name
                contract_on:   @project.contract_on
                contract_type: @project.contract_type
                start_on:      @project.start_on
                end_on:        @project.end_on
                amount:        @project.amount
                orderer_company_name:    @project.orderer_company_name
                orderer_department_name: @project.orderer_department_name
                orderer_personnel_names: @orderer_personnel_names
                orderer_address:         @project.orderer_address
                orderer_zip_code:        @project.orderer_zip_code
                orderer_memo:            @project.orderer_memo
                billing_company_name:    @project.billing_company_name
                billing_department_name: @project.billing_department_name
                billing_personnel_names: @billing_personnel_names
                billing_address:         @project.billing_address
                billing_zip_code:        @project.billing_zip_code
                billing_memo:            @project.billing_memo
          else
            postData =
              project:
                contracted:    @project.contracted
                key:           @project.key
                name:          @project.name
                contract_on:   @project.contract_on
                orderer_company_name:    @project.orderer_company_name
                orderer_department_name: @project.orderer_department_name
                orderer_personnel_names: @orderer_personnel_names
                orderer_address:         @project.orderer_address
                orderer_zip_code:        @project.orderer_zip_code
                orderer_memo:            @project.orderer_memo
                billing_company_name:    @project.billing_company_name
                billing_department_name: @project.billing_department_name
                billing_personnel_names: @billing_personnel_names
                billing_address:         @project.billing_address
                billing_zip_code:        @project.billing_zip_code
                billing_memo:            @project.billing_memo
          $.ajax
            url: '/api/projects.json'
            type: 'POST'
            data: postData
          .done (response) =>
            toastr.success('', response.message)
            @project = $.extend(true, {}, @project_init)
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
