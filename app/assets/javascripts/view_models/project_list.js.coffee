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
      contractStatus: undefined
      start: undefined
      end: undefined
      progressProject: true
      today: new Date()
      finishedStatus: undefined
      postDate : undefined
    watch:
      progressProject: (val) ->
        if val == true
          @postDate = @today.getFullYear() + '-' + ( @today.getMonth() + 1 ) + '-' + @today.getDate()
        else
          @postDate = undefined
        @search()
      finishedStatus: (val) ->
        @finished = if val == true then '終了' else undefined
        @search()
    methods:
      loadProjects: ->
        $.ajax '/api/projects.json'
          .done (response) =>
            @list = response
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
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @postDate = @today.getFullYear() + '-' + ( @today.getMonth() + 1 ) + '-' + @today.getDate()
      @search()
    events:
      loadProjectsEvent: ->
        @loadProjects()
