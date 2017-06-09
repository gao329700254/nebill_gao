$ ->
  Vue.component 'projectDetail',
    template: '#project_detail'
    mixins: [Vue.modules.projectHelper]
    props: ['projectId']
    data: ->
      editMode: false
      project: undefined
      projectOriginal: undefined
    watch:
      projectId: ->
        @loadProject()
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
      submit: ->
        try
          submit = $('.project_detail__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/projects/#{@projectId}.json"
            type: 'PATCH'
            data:
              project: @projectPostData
          .done (response) =>
            toastr.success('', response.message)
            @loadProject()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.project_detail__form__delete_btn')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/projects/#{@projectId}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/projects/list'
            .fail (response) =>
              json = response.responseJSON
              toastr.error(json.errors.full_message.join('<br>'), json.message, { timeout: 0 })
        finally
          destroy.prop('disabled', false)
    created: -> @initializeProject()
