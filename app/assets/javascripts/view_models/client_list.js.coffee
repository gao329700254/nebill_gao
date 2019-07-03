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
      is_valid: false
      sortKey: 'id'
      statuses: []
    methods:
      loadClients: ->
        $.ajax '/api/clients.json'
          .done (response) =>
            @list = response
      loadStatuses: ->
        $.ajax '/api/clients/statuses.json'
          .done (response) =>
            @statuses = response
      linkToShow: (clientId) -> window.location = "/clients/#{clientId}/show"
      showClientNew: -> @$broadcast('showClientNewEvent')
    compiled: ->
      @loadClients()
      @loadStatuses()
    events:
      loadClientsEvent: ->
        @loadClients()
