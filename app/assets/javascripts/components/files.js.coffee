$ ->
  Vue.component 'files',
    template: '#files'
    props: ['projectId']
    events:
      uploadFileEvent: ->
        @$broadcast('loadFilesEvent')
        @$dispatch('loadLastUpdatedAtEvent')
      updateFileEvent: -> @$dispatch('loadLastUpdatedAtEvent')
      deleteFileEvent: -> @$dispatch('loadLastUpdatedAtEvent')
