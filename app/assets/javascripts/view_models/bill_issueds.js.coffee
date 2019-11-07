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
      billId: undefined
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      submit: (billId) ->
        console.log(@list)
        try
          $.ajax
            url: "/api/bill_issueds/#{billId}.json"
            type: 'PATCH'
            data: {
              bill: {
                memo: @list[2].memo
              }
            }
          .done (response) =>
            toastr.success('', response.message)
            @loadBillIssued()
          .fail (response) =>
            json = response.responseJSON
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
      loadBillIssued: (billId) ->
        $.ajax 
          url: "/api/bill_issueds/#{billId}.json"
          type: 'PATCH'
          .done (response) =>
            @billOriginal = response
            @bill = $.extend(true, {}, @billOriginal)
          .fail (response) =>
            console.error response
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
