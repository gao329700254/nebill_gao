$ ->
  window.agreementList = new Vue
    el: '#agreement_list'
    data:
      currentView: undefined
    methods:
      viewShow: (view) ->
        page.show view

  page hashbang: true, dispatch: false
  page 'agreement_approval_list', (ctx) ->
    agreementList.currentView = 'agreementApprovalList'
  page 'agreement_client_list', (ctx) ->
    agreementList.currentView = 'agreementClientList'
  page 'agreement_project_list', (ctx) ->
    agreementList.currentView = 'agreementProjectList'
  page 'agreement_bill_list', (ctx) ->
    agreementList.currentView = 'agreementBillList'
  page 'agreement_expense_approval_list', (ctx) ->
    agreementList.currentView = 'agreementExpenseApprovalList'
