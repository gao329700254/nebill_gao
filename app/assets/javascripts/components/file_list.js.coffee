$ ->
  Vue.component 'fileList',
    template: '#file_list'
    props: ['projectId']
    data: ->
      files: []
      sortKey: 'id'
    methods:
      loadFiles: ->
        $.ajax "/api/projects/#{@projectId}/project_files.json"
          .done (response) =>
            @files = response
    events:
      loadFilesEvent: -> @loadFiles()
    compiled: ->
      @loadFiles()
