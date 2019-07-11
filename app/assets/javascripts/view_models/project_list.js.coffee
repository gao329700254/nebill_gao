$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      selectSchema:
        cd: 'like'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
      contractStatus: []
      projectStatus: []
      start: undefined
      end: undefined
    methods:
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
      showProjectNew: -> @$broadcast('showProjectNewEvent')
      search: ->
        try
          search = $('.project_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/projects/search_result.json'
            type: 'POST'
            data: {
              start: @start
              end: @end
            }
          .done (response) =>
            @list = @reverseList(response)
        finally
          search.prop('disabled', false)
      reverseList: (list) ->
        compareUpdatedAt = (a, b) ->
          if b.updated_at >= a.updated_at then 1 else -1
        sortedList = list.slice().sort(compareUpdatedAt)
    compiled: ->
      @search()
    events:
      loadSearchEvent: ->
        @search()
