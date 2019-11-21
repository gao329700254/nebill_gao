$ ->
  window.partnerShow = new Vue
    el: '#partner_show'
    data:
      editMode:           false
      partnerId:          undefined
      partner:            undefined
      partnerOriginal:    undefined
      allClients:         undefined
      client:             undefined
      clientOriginal:     undefined
    watch:
      partnerId: ->
        @loadPartner()
        @loadAllClients()
    methods:
      loadPartner: ->
        $.ajax
          url: "/api/partners/#{@partnerId}"
          type: 'GET'
        .done (response) =>
          @partnerOriginal = response.partner
          @partner = Object.assign({}, @partnerOriginal)
          @clientOriginal = response.client
          @client = Object.assign({}, @clientOriginal)
        .fail (response) =>
          console.error response
      loadAllClients: ->
        $.ajax '/api/clients/published_clients.json'
          .done (response) => @allClients = response
      loadSelectedClient: ->
        clientId = $('#client_id').val()
        $.ajax "/api/clients/#{clientId}"
          .done (response) =>
            @client = {
              id:           response.id,
              client_info:  response.client_info,
            }
      resetPartner: ->
        @partner = Object.assign({}, @partnerOriginal)
        @editMode = false
      submit: ->
        try
          form = new FormData()
          form.append('partner[name]', @partner.name)
          form.append('partner[email]', @partner.email)
          form.append('partner[client_id]', @client.id) if @client.id
          $.ajax
            url: "/api/partners/#{@partnerId}.json"
            type: 'PATCH'
            data: form
            contentType: false
            processData: false
          .done (response) =>
            toastr.success('', response.message)
            @loadPartner()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
      destroy: ->
        try
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/partners/#{@partnerId}"
              type: 'DELETE'
            .done (response) =>
              window.location = '/partners/list'
              toastr.success('', response.message)
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
      linkToList: -> window.location = '/partners/list'
