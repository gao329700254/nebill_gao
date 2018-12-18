$ ->
  window.clientShow = new Vue
    el: '#client_show'
    data:
      clientId: undefined
      approvalId: undefined
      clientSchema:
        id:               { init: '' }
        cd:               { init: '' }
        company_name:     { init: '' }
        department_name:  { init: '' }
        address:          { init: '' }
        zip_code:         { init: '' }
        phone_number:     { init: '' }
        status_num:       { init: '' }
        memo:             { init: '' }
      nda:                 ''
      basic_contract:      ''
      nda_id:              ''
      basic_contract_id:   ''
      nda_file:            ''
      basic_contract_file: ''
      nda_legal_check:                false
      basic_contract_legal_check:     false
      editMode: false
      client: undefined
      clientOriginal: undefined
      url: undefined
      approval_status: undefined
      approval_user: []
    filters:
      truncate: (value) ->
        if value.length > 40
          value = value.substring(0, 37) + '...'
        value
      match: (value) ->
        if value
          value.match(/(.pdf|.png|.jpg|.jpeg|.gif)$/i)
    computed:
      clientInit: -> _.mapObject @clientShema, (value, key) -> value.init
    watch:
      clientId: ->
        @loadClient()
      editMode: (val) ->
        @client = $.extend(true, {}, @clientOriginal) unless val
    methods:
      initializeClient: -> @client = $.extend(true, {}, @clientInit)
      loadClient: ->
        $.ajax "/api/clients/#{@clientId}.json"
          .done (response) =>
            @clientOriginal = response
            @client = $.extend(true, {}, @clientOriginal)
          .fail (response) =>
            console.error response
      submit: ->
        try
          submit = $('.client_show__form__btn--submit')
          submit.prop('disabled', true)
          form = new FormData()
          if @nda != ''
            form.append('client[files_attributes][0][id]', @nda_id)
            form.append('client[files_attributes][0][file]', @nda)
            form.append('client[files_attributes][0][file_type]', '10')
            form.append('client[files_attributes][0][legal_check]', @nda_legal_check)
          if @basic_contract != ''
            form.append('client[files_attributes][1][id]', @basic_contract_id)
            form.append('client[files_attributes][1][file]', @basic_contract)
            form.append('client[files_attributes][1][file_type]', '20')
            form.append('client[files_attributes][1][legal_check]', @basic_contract_legal_check)
          form.append('client[cd]', @client.cd)
          form.append('client[company_name]', @client.company_name)
          form.append('client[department_name]', @client.department_name)
          form.append('client[address]', @client.address)
          form.append('client[zip_code]', @client.zip_code)
          form.append('client[phone_number]', @client.phone_number)
          form.append('client[memo]', @client.memo)
          form.append('approval_id', @approvalId)
          $.ajax
            url: "/api/clients/#{@clientId}.json"
            type: 'PATCH'
            data: form
            cache: false
            contentType: false
            processData: false
          .done (response) =>
            toastr.success('', response.message)
            @loadClient()
            @getApprovalUser()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      ndaInputChange: (e) ->
        @nda = e.target.files[0]
      basicContractInputChange: (e) ->
        @basic_contract = e.target.files[0]
      showClientFile: (element) ->
        @url = element
        if element.includes('.pdf')
          window.open(element)
        else
          @$broadcast('showClientFileEvent')
      getApprovalUser: ->
        $.ajax
          url: '/api/clients/set_approval_user.json'
          type: 'POST'
          data: {
            approval_id: @approvalId
          }
        .done (response) =>
          @approval_user = response
    created: -> @initializeClient()
    compiled: -> @getApprovalUser()
