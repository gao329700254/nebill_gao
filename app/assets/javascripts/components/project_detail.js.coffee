$ ->
  Vue.component 'projectDetail',
    template: '#project_detail'
    mixins: [Vue.modules.projectHelper, Vue.modules.numericHelper]
    props: ['projectId']
    data: ->
      approvalId:undefined
      editMode: false
      project: undefined
      projectOriginal: undefined
      options: []
      clients: []
      ordererClientId: undefined
      billingClientId: undefined
      allUsers: []
      url: undefined
      file_id: ''
      file: ''
      approval_user: []
      approval_status: undefined
    filters:
      truncate: (value) ->
        if value.length > 40
          value = value.substring(0, 37) + '...'
        value
      match: (value) ->
        if value
          value.match(/(.pdf|.png|.jpg|.jpeg|.gif)$/i)
    watch:
      projectId: ->
        @loadProject()
        @statusList()
      editMode: (val) ->
        unless val
          @project = $.extend(true, {}, @projectOriginal)
          @project.amount = parseInt(@project.amount).toLocaleString()
          @project.estimated_amount = parseInt(@project.estimated_amount).toLocaleString()
    methods:
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @projectOriginal = response
            @project = $.extend(true, {}, @projectOriginal)
            @project.amount = if @project.amount then parseInt(@project.amount).toLocaleString() else ''
            @project.estimated_amount = if @project.estimated_amount then parseInt(@project.estimated_amount).toLocaleString() else ''
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
          formData = new FormData()
          unless @project.contracted
            @project = _.pick @project, (value, key) => key != 'amount' && key != 'payment_type'
          @project = _.pick @project, (value, key) => key != 'group_id' && value != null
          Object.keys(@project).forEach (key) =>
            formData.append("project[#{key}]", @project[key])
          formData.append('approval_id', @approvalId)
          formData.append('appr_comment', @approval_user.comment)
          if @file
            formData.append('file', @file)
          if(!$('[name=unprocessed]:checked').val() || confirm($('#header__unprocessed_confirm_message').val()))
            $.ajax
              url: "/api/projects/#{@projectId}.json"
              type: 'PATCH'
              data: formData
              cache: false
              contentType: false
              processData: false
            .done (response) =>
              toastr.success('', response.message)
              @loadProject()
              @getApprovalUser()
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
      loadAllUsers: ->
        $.ajax '/api/users'
          .done (response) =>
            @allUsers = response
      showProjectFile: (element) ->
        @url = element
        if element.includes('.pdf')
          window.open(element)
        else
          @$broadcast('showProjectFileEvent')
      fileInputChange: (e) ->
        @file = e.target.files[0]
      getApprovalUser: ->
        if @approvalId
          $.ajax
            url: '/api/clients/set_approval_user.json'
            type: 'POST'
            data: {
              approval_id: @approvalId
            }
          .done (response) =>
            @approval_user = response
    created: ->
      @initializeProject()
      @loadClients()
      @loadAllUsers()
    compiled: -> @getApprovalUser()
    events:
      loadStatusEvent: ->
        @statusList()
