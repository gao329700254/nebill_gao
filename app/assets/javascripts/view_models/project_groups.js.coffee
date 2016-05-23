$ ->
  window.projectGroups = new Vue
    el: '#project_groups'
    data:
      projectGroupList: undefined
      projectGroup:
        name: ''
    methods:
      loadProjectGroup: ->
        $.ajax '/api/project_groups.json'
          .done (response) =>
            @projectGroupList = response
      createProjectGroup: ->
        try
          submit = $('.project_groups__new__input__btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/project_groups.json'
            type: 'POST'
            data:
              project_group: @projectGroup
          .done (response) =>
            toastr.success('', response.message)
            @projectGroup.name = ''
            @loadProjectGroup()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
    created: ->
      @loadProjectGroup()
