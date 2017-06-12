$ ->
  Vue.component 'partnerNew',
    template: '#partner_new'
    mixins: [Vue.modules.modal]
    data: ->
      partner:
        cd: ''
        email: ''
        name: ''
        company_name: ''
        address: ''
        zip_code: ''
        phone_number: ''
    methods:
      cancel: -> @modalHide()
      submit: ->
        try
          submit = $('.partner_new__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/partners.json'
            type: 'POST'
            data: { partner: @partner }
          .done (response) =>
            toastr.success('', response.message)
            @partner.cd           = ''
            @partner.email        = ''
            @partner.name         = ''
            @partner.company_name = ''
            @partner.address      = ''
            @partner.zip_code     = ''
            @partner.phone_number = ''
            @modalHide()
            @$dispatch('loadAllPartnersEvent', response.id)
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
    events:
      showPartnerNewEvent: -> @modalShow()
