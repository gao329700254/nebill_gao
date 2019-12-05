$ ->
  window.projectNewForm = new Vue
    el: '#partner_new'
    mixins: [Vue.modules.modal]
    data: ->
      partner:    {}
      allClients: undefined
      client:     {}
    created: ->
      $.ajax '/api/clients/published_clients.json'
        .done (response) => @allClients = response
    methods:
      loadSelectedClient: ->
        clientId = $('#client_id').val()
        $.ajax "/api/clients/#{clientId}"
          .done (response) =>
            @client = {
              id:           response.id,
              client_info:  response.client_info,
            }
      cancel: ->
        window.location = '/partners/list'
      submit: ->
        try
          form = new FormData()
          form.append('partner[name]', @partner.name)
          form.append('partner[email]', @partner.email)
          form.append('partner[client_id]', @client.id) if @client.id
          $.ajax
            url: '/api/partners'
            type: 'POST'
            data: form
            contentType: false
            processData: false
          .done (response) =>
            toastr.success('', response.message)
            window.location = "/partners/#{response.id}/show"
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
