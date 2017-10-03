$ ->
  Vue.component 'fileList',
    template: '#file_list'
    props: ['projectId']
    data: ->
      group_name: undefined
      fileGroups: []
      files: []
      fileGroupId: undefined
      sortKey: 'group.id'
      project:
        status: undefined
    computed:
      selectedFiles: -> _.filter @files, (f) -> f.selected
    methods:
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @project = response
      createFileGroup: ->
        try
          submit = $('.file_list__group_new__btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/projects/#{@projectId}/project_file_groups.json"
            type: 'POST'
            data:
              project_file_group:
                name: @group_name
          .done (response) =>
            toastr.success('', response.message)
            @group_name = ''
            @loadFileGroups()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      loadFileGroups: ->
        $.ajax "/api/projects/#{@projectId}/project_file_groups.json"
          .done (response) =>
            @fileGroups = response
      loadFiles: ->
        $.ajax "/api/projects/#{@projectId}/project_files.json"
          .done (response) =>
            $.each response, (i, r) -> r.selected = false
            @files = response
      updateFiles: ->
        $.each @selectedFiles, (i, file) =>
          $.ajax
            url: "/api/project_files/#{file.id}.json"
            type: 'PATCH'
            data:
              project_file: { file_group_id: @fileGroupId }
          .done (response) =>
            toastr.success('', response.message)
            @loadFiles()
          .fail (response) =>
            json = response.responseJSON
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
      deleteFiles: ->
        try
          destroy = $('.file_list__group_delete__btn')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.each @selectedFiles, (i, file) =>
              $.ajax
                url: "/api/project_files/#{file.id}.json"
                type: 'DELETE'
              .done (response) =>
                toastr.success('', response.message)
                @loadFiles()
              .fail (response) =>
                json = response.responseJSON
                if _.has(json, 'errors')
                  toastr.error(json.errors.full_messages.join('<br>'), json.message)
                else
                  toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
    events:
      loadFilesEvent: -> @loadFiles()
      loadProjectEvent: ->
        @loadProject()
    compiled: ->
      @loadFileGroups()
      @loadFiles()
      @loadProject()
