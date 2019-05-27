$ ->
  Vue.component 'projectFile',
    template: '#project_file'
    mixins: [Vue.modules.modal]
    props: ['url']
    events:
      showProjectFileEvent: ->
        @modalShow()
