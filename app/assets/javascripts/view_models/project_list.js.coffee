$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      selectSchema:
        cd: 'eq'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
      contractStatus: []
      start: undefined
      end: undefined
      progressProject: false
      today: new Date()
      finishedStatus: undefined
      postDate : undefined
      unprocessedProject : undefined
    watch:
      progressProject: (val) ->
        if val == true
          @postDate = @today.getFullYear() + '-' + ( @today.getMonth() + 1 ) + '-' + @today.getDate()
        else
          @postDate = undefined
        @search()
      unprocessedProject: (val) ->
        if val == true
          @unprocessedProject = true
        else
          @unprocessedProject = undefined
        @search()
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
              today: @postDate
              unprocessed: @unprocessedProject
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @search()
    events:
      loadSearchEvent: ->
        @search()
