$ ->
  Vue.component 'projectBillList',
    template: '#project_bill_list'
    props: ['projectId']
    data: ->
      list: undefined
      sortKey: 'created_at'
      project:
        status: undefined
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      loadBillList: ->
        $.ajax "/api/projects/#{@projectId}/bills.json"
          .done (response) =>
            @list = response
        @$dispatch('loadLastUpdatedAtEvent')
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @project = response
      showBillNew: -> @$broadcast('showBillNewEvent')
    compiled: ->
      @loadBillList()
      @loadProject()
    events:
      loadBillListEvent: -> @loadBillList()
      loadProjectEvent: -> @loadProject()
