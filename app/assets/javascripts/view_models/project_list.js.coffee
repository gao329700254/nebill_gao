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
    methods:
      loadProjects: ->
        $.ajax '/api/projects.json'
          .done (response) =>
            @list = response
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
      showProjectNew: -> @$broadcast('showProjectNewEvent')
    compiled: ->
      @loadProjects()
    events:
      loadProjectsEvent: ->
        @loadProjects()
