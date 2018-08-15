$ ->
  Vue.component 'expenseFile',
    template: '#expense_file'
    mixins: [Vue.modules.modal]
    props: ['url']
    events:
      showExpenseFileEvent: ->
        @modalShow()
