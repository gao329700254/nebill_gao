$ ->
  Vue.component 'projectNew',
    template: '#project_new'
    mixins: [Vue.modules.projectHelper, Vue.modules.modal]
    data: ->
      clients: []
      project: undefined
      ordererClientId: undefined
      billingClientId: undefined
      client:
        company_name:     undefined
        department_name:  undefined
        address:          undefined
        zip_code:         undefined
        phone_number:     undefined
        memo:             undefined
    methods:
      cancel: -> @modalHide()
      setProjectCd: ->
        projectType =
          if @project.contracted == false
            'uncontracted'
          else if @project.is_using_ses == true
            'ses'
          else
            @project.contract_type
        $.ajax "/api/projects/cd/#{projectType}.json"
          .done (response) =>
            @project.cd = response.cd
      loadClients: ->
        $.ajax '/api/clients.json'
          .done (response) =>
            @clients = [{
              id: 0,
              cd: '新規作成',
              company_name: '',
            }]
            response.forEach (element) =>
              @clients.push(element)
      fillOrderer: ->
        $.ajax "/api/clients/#{@ordererClientId}.json"
          .done (response) =>
            @project.orderer_company_name     = response.company_name
            @project.orderer_department_name  = response.department_name
            @project.orderer_address          = response.address
            @project.orderer_zip_code         = response.zip_code
            @project.orderer_phone_number     = response.phone_number
      fillBilling: ->
        $.ajax "/api/clients/#{@billingClientId}.json"
          .done (response) =>
            @project.billing_company_name     = response.company_name
            @project.billing_department_name  = response.department_name
            @project.billing_address          = response.address
            @project.billing_zip_code         = response.zip_code
            @project.billing_phone_number     = response.phone_number
      copy: ->
        @project.billing_company_name    = @project.orderer_company_name
        @project.billing_department_name = @project.orderer_department_name
        @project.billing_personnel_names = @project.orderer_personnel_names
        @project.billing_address         = @project.orderer_address
        @project.billing_zip_code        = @project.orderer_zip_code
        @project.billing_phone_number    = @project.orderer_phone_number
      copy_client: ->
        @client.company_name    = @project.orderer_company_name
        @client.department_name = @project.orderer_department_name
        @client.address         = @project.orderer_address
        @client.zip_code        = @project.orderer_zip_code
        @client.phone_number    = @project.orderer_phone_number
      submit: ->
        try
          submit = $('.project_new__form__submit_btn')
          submit.prop('disabled', true)
          if $('#orderer_client_id').val() == '0'
            @copy_client()
            $.ajax
              url: '/api/projects/create_with_client.json'
              type: 'POST'
              data: { project: @projectPostData, client: @client }
            .done (response) =>
              toastr.success('', response.message)
              @initializeProject()
              @modalHide()
              @$dispatch('loadProjectsEvent')
            .fail (response) =>
              json = response.responseJSON
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
          else
            $.ajax
              url: '/api/projects.json'
              type: 'POST'
              data: { project: @projectPostData }
            .done (response) =>
              toastr.success('', response.message)
              @initializeProject()
              @modalHide()
              @$dispatch('loadProjectsEvent')
            .fail (response) =>
              json = response.responseJSON
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
    created: ->
      @loadClients()
      @initializeProject()
      @setProjectCd()
    events:
      showProjectNewEvent: -> @modalShow()
