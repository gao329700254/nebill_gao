$ ->
  window.billList = new Vue
    el: '#bill_list'
    data:
      sortKey: 'key'
      selectSchema:
        key: 'like'
        'project.name': 'like'
        'project.billing_company_name': 'like'
      list: undefined
      searchKeywords: undefined
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
    compiled: ->
      $.ajax '/api/bills.json'
        .done (response) =>
          @list = response
