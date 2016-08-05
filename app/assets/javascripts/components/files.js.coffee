$ ->
  Vue.component 'files',
    template: '#files'
    props: ['projectId']
    events:
      uploadFileEvent: -> @$broadcast('loadFilesEvent')
