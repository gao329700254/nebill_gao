$ ->
  Vue.component 'agreementApprovalList',
    template: '#agreement_approval_list'
    data: ->
      list: []
    methods:
      loadList: ->
        $.ajax '/api/agreements/approval_list.json'
          .done (response) =>
            @list = response
      linkToShow: (approvalId) -> window.location = "/approvals/#{approvalId}/show"
    compiled: ->
      @loadList()
