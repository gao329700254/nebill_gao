$ ->
  window.project_list = new Vue
    el:  '#project_list'
    data:
      sortKey: 'contract_on'
      list: undefined
    compiled: ->
      $.ajax '/api/projects.json'
        .done (response) =>
          @list = response
