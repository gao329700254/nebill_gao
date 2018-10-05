$ ->
  Vue.component 'approvalFile',
    template: '#approval_file'
    mixins: [Vue.modules.modal]
    props: ['url']
    events:
      showApprovalFileEvent: ->
        @modalShow()
