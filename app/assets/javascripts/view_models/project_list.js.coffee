$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      sortKey: 'contract_on'
      selectSchema:
        key: 'eq'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
    methods:
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
    compiled: ->
      $.ajax '/api/projects.json'
        .done (response) =>
          @list = response
