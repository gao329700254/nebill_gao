$ ->
  Vue.component 'clientNew',
    template: '#client_new'
    mixins: [Vue.modules.modal]
    data: ->
      client:
        company_name:                 ''
        department_name:              ''
        address:                      ''
        zip_code:                     ''
        phone_number:                 ''
        memo:                         ''
      nda:                            ''
      basic_contract:                 ''
      add_contract:                   false
      nda_legal_check:                false
      basic_contract_legal_check:     false
    methods:
      cancel: -> @modalHide()
      submit: ->
        try
          submit = $('.client_new__form__submit_btn')
          submit.prop('disabled', true)
          form = new FormData()
          if @nda != ''
            form.append('client[files_attributes][0][file]', @nda)
            form.append('client[files_attributes][0][file_type]', '10')
            form.append('client[files_attributes][0][legal_check]', @nda_legal_check)
          if @basic_contract != ''
            form.append('client[files_attributes][1][file]', @basic_contract)
            form.append('client[files_attributes][1][file_type]', '20')
            form.append('client[files_attributes][1][legal_check]', @basic_contract_legal_check)
          form.append('client[company_name]', @client.company_name)
          form.append('client[department_name]', @client.department_name)
          form.append('client[address]', @client.address)
          form.append('client[zip_code]', @client.zip_code)
          form.append('client[phone_number]', @client.phone_number)
          form.append('client[memo]', @client.memo)
          $.ajax
            url: '/api/clients.json'
            type: 'POST'
            data: form
            cache: false
            contentType: false
            processData: false
          .done (response) =>
            toastr.success('', response.message)
            @client = _.mapObject @client, (v, k) -> undefined
            @modalHide()
            @$dispatch('loadClientsEvent')
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      ndaInputChange: (e) ->
        @nda = e.target.files[0]
        @add_contract = true
      basicContractInputChange: (e) ->
        @basic_contract = e.target.files[0]
    events:
      showClientNewEvent: -> @modalShow()
