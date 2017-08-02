$ ->
  window.clientList = new Vue
    el:  '#client_list'
    data:
      selectSchema:
        cd:               'eq'
        company_name:     'like'
        department_name:  'like'
        phone_number:     'eq'
      list: undefined
      searchKeywords: undefined
      sortKey: 'id'
    methods:
      loadClients: ->
        $.ajax '/api/clients.json'
          .done (response) =>
            @list = response
      linkToShow: (clientId) -> window.location = "/clients/#{clientId}/show"
      showClientNew: -> @$broadcast('showClientNewEvent')
    compiled: ->
      @loadClients()
    events:
      loadClientsEvent: ->
        @loadClients()
