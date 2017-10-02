$ ->
  Vue.component 'projectBillList',
    template: '#project_bill_list'
    props: ['projectId']
    data: ->
      list: undefined
      sortKey: 'created_at'
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      loadBillList: ->
        $.ajax "/api/projects/#{@projectId}/bills.json"
          .done (response) =>
            @list = response
      showBillNew: -> @$broadcast('showBillNewEvent')
    compiled: ->
      @loadBillList()
    events:
      loadBillListEvent: -> @loadBillList()
