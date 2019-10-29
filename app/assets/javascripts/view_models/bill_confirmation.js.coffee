$ ->
  window.billConfirmation = new Vue
    el: '#bill_confirmation'
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
    methods:
      linkToShow: (billId) -> window.location = "/bills/#{billId}/show"
      search: ->
        try
          search = $('.bill_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/bills/search_result.json'
            type: 'POST'
            data: {
              start: @start
              end: @end
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      $.ajax '/api/bills.json'
        .done (response) =>
          @list = response
