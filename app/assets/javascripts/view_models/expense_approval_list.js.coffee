$ ->
  window.ExpenseApprovalList = new Vue
    el: '#expense_approval_list'
    data:
      sortKey: 'id'
      selectSchema:
        name: 'like'
        created_user_name: 'like'
      list: undefined
      searchKeywords: ''
      status: ''
      created_at: ''
    watch:
      searchKeywords: (newSearchKeywords) ->
        localStorage.searchKeywords = newSearchKeywords
      status: (newStatus) ->
        localStorage.status = newStatus
      created_at: (newCreated_at) ->
        localStorage.created_at = newCreated_at
    methods:
      loadLocalStorage: ->
        if localStorage.searchKeywords
          @searchKeywords = localStorage.searchKeywords
        if localStorage.status
          @status = localStorage.status
        if localStorage.created_at
          @created_at = localStorage.created_at
      linkToShow: (expenseApprovalId) -> window.location = "/expense/approval/#{expenseApprovalId}/show"
      search: ->
        try
          search = $('.expense_approval_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/expense_approvals/search_result.json'
            type: 'POST'
            data: {
              created_at: @created_at
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @loadLocalStorage()
      @search()
