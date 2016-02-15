$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      sortKey: 'contract_on'
      list: undefined
    methods:
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
    compiled: ->
      $.ajax '/api/projects.json'
        .done (response) =>
          @list = response
