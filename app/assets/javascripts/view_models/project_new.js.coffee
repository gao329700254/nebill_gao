$ ->
  window.projectNew = new Vue
    el: '#project_new'
    mixins: [Vue.modules.projectHelper]
    data:
      clients: []
      project: undefined
      ordererClientId: undefined
      billingClientId: undefined
    methods:
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
            @clients = response
      fillOrderer: ->
        $.ajax "/api/clients/#{@ordererClientId}.json"
          .done (response) =>
            @project.orderer_company_name     = response.company_name
            @project.orderer_department_name  = response.department_name
            @project.orderer_address          = response.address
            @project.orderer_zip_code         = response.zip_code
      fillBilling: ->
        $.ajax "/api/clients/#{@billingClientId}.json"
          .done (response) =>
            @project.billing_company_name     = response.company_name
            @project.billing_department_name  = response.department_name
            @project.billing_address          = response.address
            @project.billing_zip_code         = response.zip_code
      copy: ->
        @project.billing_company_name    = @project.orderer_company_name
        @project.billing_department_name = @project.orderer_department_name
        @project.billing_personnel_names = @project.orderer_personnel_names
        @project.billing_address         = @project.orderer_address
        @project.billing_zip_code        = @project.orderer_zip_code
      submit: ->
        try
          submit = $('.project_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/projects.json'
            type: 'POST'
            data: { project: @projectPostData }
          .done (response) =>
            toastr.success('', response.message)
            @initializeProject()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
    created: ->
      @loadClients()
      @initializeProject()
      @setProjectCd()
