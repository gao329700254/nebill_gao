$ ->
  window.clientNew = new Vue
    el: '#client_new'
    data:
      client:
        cd:               ''
        company_name:     ''
        department_name:  ''
        address:          ''
        zip_code:         ''
        phone_number:     ''
        memo:             ''
    methods:
      submit: ->
        try
          submit = $('.client_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/clients.json'
            type: 'POST'
            data: { client: @client }
          .done (response) =>
            toastr.success('', response.message)
            @client = _.mapObject @client, (v, k) -> undefined
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
