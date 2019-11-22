$ ->
  window.billIssueds = new Vue
    el: '#bill_issueds_list'
    data:
      sortKey: 'cd'
      selectSchema:
        cd: 'like'
        'project.name': 'like'
        'project.billing_company_name': 'like'
      list: undefined
      searchKeywords: undefined
      status: ''
      expected_deposit_on_start: undefined
      expected_deposit_on_end: undefined
      buttonTextNotConfirmed: '未確認'
      buttonTextConfirmed: '確認済'
      billId: undefined
    watch:
      status: (checkedStatus) ->
        localStorage.status = checkedStatus
    methods:
      loadIssuedBillsList: ->
        $.ajax
          url: '/api/bill_issueds.json'
          type: 'GET'
        .done (response) =>
          @list = response
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      showBillIssuedEdit: (bill) ->
        @$broadcast('showBillIssuedEditEvent', bill)
      notConfirmedStatus: (bill) ->
        bill.status == '発行済み'
      ConfirmedStatus: (bill) ->
        bill.status == '入金確認済み'
      search: ->
        try
          search = $('.bill_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/bill_issueds.json'
            type: 'POST'
            data: {
              expected_deposit_on_start: @expected_deposit_on_start
              expected_deposit_on_end: @expected_deposit_on_end
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @loadIssuedBillsList()
    events:
      loadIssuedBillsListEvent: ->
        @loadIssuedBillsList()
