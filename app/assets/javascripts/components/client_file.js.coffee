$ ->
  Vue.component 'clientFile',
    template: '#client_file'
    mixins: [Vue.modules.modal]
    props: ['url']
    events:
      showClientFileEvent: ->
        @modalShow()
