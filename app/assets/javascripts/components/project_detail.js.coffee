$ ->
  Vue.component 'projectDetail',
    template: '#project_detail'
    mixins: [Vue.modules.projectHelper]
    props: ['projectId']
    data: ->
      editMode: false
      project: undefined
      projectOriginal: undefined
      options: []
      clients: []
      ordererClientId: undefined
      billingClientId: undefined
    watch:
      projectId: ->
        @loadProject()
        @statusList()
      editMode: (val) ->
        @project = $.extend(true, {}, @projectOriginal) unless val
    methods:
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @projectOriginal = response
            @project = $.extend(true, {}, @projectOriginal)
          .fail (response) =>
            console.error response
      statusList: ->
        $.ajax "/api/projects/#{@projectId}/select_status.json"
          .done (response) =>
            @options = response
      submit: ->
        try
          submit = $('.project_detail__form__btn--submit')
          submit.prop('disabled', true)
            
          if(!$('[name=unprocessed]:checked').val() || confirm($('#header__unprocessed_confirm_message').val()))
            $.ajax
              url: "/api/projects/#{@projectId}.json"
              type: 'PATCH'
              data:
                project: @projectPostData
            .done (response) =>
              toastr.success('', response.message)
              @loadProject()
              @editMode = false
              @$dispatch('updateProjectEvent')
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.project_detail__form__btn--delete')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/projects/#{@projectId}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/projects/list'
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      loadClients: ->
        $.ajax '/api/clients/published_clients.json'
          .done (response) =>
            @clients = []
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
    created: ->
      @initializeProject()
      @loadClients()
    events:
      loadStatusEvent: ->
        @statusList()
