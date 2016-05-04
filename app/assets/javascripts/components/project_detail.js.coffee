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
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
    created: -> @initializeProject()
