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
      start: undefined
      end: undefined
      buttonText: '未確認'
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      changeButton: (billId) -> window.location = "/bills/#{billId}/show"
      search: ->
        try
          search = $('.bill_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/bill_issueds/search_result.json'
            type: 'POST'
            data: {
              start: @start
              end: @end
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
      LoadIssuedBillsList: ->
        $.ajax 
          url: '/api/bill_issueds.json'
          type: 'GET'
        .done (response) =>
          @list = response

    compiled: ->
      @LoadIssuedBillsList()

