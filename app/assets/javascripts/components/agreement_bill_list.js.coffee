$ ->
  Vue.component 'agreementBillList',
    template: '#agreement_bill_list'
    data: ->
      list: []
    methods:
      loadList: ->
        $.ajax '/api/agreements/bill_list.json'
          .done (response) =>
            @list = response
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
    compiled: ->
      @loadList()
