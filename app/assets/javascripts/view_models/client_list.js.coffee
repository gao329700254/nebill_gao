$ ->
  window.clientList = new Vue
    el:  '#client_list'
    data:
      selectSchema:
        key:              'eq'
        company_name:     'like'
        department_name:  'like'
        phone_number:     'eq'
      list: undefined
      searchKeywords: undefined
      sortKey: 'id'
    methods:
      linkToShow: (clientId) -> window.location = "/clients/#{clientId}/show"
    compiled: ->
      $.ajax '/api/clients.json'
        .done (response) =>
          @list = response
