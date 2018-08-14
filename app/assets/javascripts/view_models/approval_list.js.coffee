$ ->
  window.approvalList = new Vue
    el: '#approval_list'
    data:
      sortKey: 'id'
      selectSchema:
        name: 'like'
        created_user_name: 'like'
      list: undefined
      searchKeywords: undefined
      status: undefined
      created_at: undefined
    methods:
      linkToShow: (approvalId) -> window.location = "/approvals/#{approvalId}/show"
      showApprovalNew: -> window.location = '/approvals/new'
      search: ->
        try
          search = $('.approval_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/approvals/search_result.json'
            type: 'POST'
            data: {
              created_at: @created_at
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      $.ajax '/api/approvals.json'
        .done (response) =>
          @list = response