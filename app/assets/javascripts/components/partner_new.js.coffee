$ ->
  Vue.component 'partnerNew',
    template: '#partner_new'
    mixins: [Vue.modules.modal]
    data: ->
      partner:
        email: ''
        name: ''
        company_name: ''
    methods:
      cancel: -> @modalHide()
      submit: ->
        try
          submit = $('.partner_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/partners.json'
            type: 'POST'
            data: { partner: @partner }
          .done (response) =>
            toastr.success('', response.message)
            @partner.email        = ''
            @partner.name         = ''
            @partner.company_name = ''
            @modalHide()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
    events:
      showPartnerNewEvent: -> @modalShow()
