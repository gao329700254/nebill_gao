$ ->
  window.approvalGroups = new Vue
    el: '#approval_groups'
    data:
      sortKey: 'id'
      selectSchema:
        name: 'like'
        users: 'like'
      list: undefined
      searchKeywords: ''
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
        if localStorage.created_at
          @created_at = localStorage.created_at
      linkToShow: (approvalId) -> window.location = "/approval_groups/#{approvalId}"
      showApprovalNew: -> window.location = '/approval_groups/new'
      search: ->
        try
          search = $('.approval_groups__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/approval_groups.json'
            type: 'GET'
            data:
              created_at: @created_at
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @loadLocalStorage()
      @search()
