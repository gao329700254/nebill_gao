$ ->
  Vue.component 'agreementClientList',
    template: '#agreement_client_list'
    data: ->
      list: []
    methods:
      loadList: ->
        $.ajax '/api/agreements/client_list.json'
          .done (response) =>
            @list = response
      linkToShow: (clientId) -> window.location = "/clients/#{clientId}/show"
    compiled: ->
      @loadList()
