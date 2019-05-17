$ ->
  Vue.component 'agreementExpenseApprovalList',
    template: '#agreement_expense_approval_list'
    data: ->
      list: []
    methods:
      loadList: ->
        $.ajax '/api/agreements/expense_approval_list.json'
          .done (response) =>
            @list = response
      linkToShow: (expenseApprovalId) -> window.location = "/expense/approval/#{expenseApprovalId}/show"
    compiled: ->
      @loadList()
