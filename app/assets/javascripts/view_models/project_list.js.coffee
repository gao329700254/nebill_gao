$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      sortKey: 'contract_on'
      selectSchema:
        cd: 'eq'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
      contractStatus: undefined
      start: undefined
      end: undefined
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
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
    compiled: ->
      @loadProjects()
    events:
      loadProjectsEvent: ->
        @loadProjects()
