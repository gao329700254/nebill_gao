$ ->
  window.clientNew = new Vue
    el: '#client_new'
    data:
      client:
        key:              undefined
        company_name:     undefined
        department_name:  undefined
        address:          undefined
        zip_code:         undefined
        phone_number:     undefined
        memo:             undefined
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
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
