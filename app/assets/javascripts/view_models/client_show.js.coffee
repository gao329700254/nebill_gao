$ ->
  window.clientShow = new Vue
    el: '#client_show'
    data:
      clientId: undefined
      clientSchema:
        id:               { init: '' }
        cd:               { init: '' }
        company_name:     { init: '' }
        department_name:  { init: '' }
        address:          { init: '' }
        zip_code:         { init: '' }
        phone_number:     { init: '' }
        memo:             { init: '' }
        created_at:       { init: '' }
        updated_at:       { init: '' }
      editMode: false
      client: undefined
      clientOriginal: undefined
    computed:
      clientInit: -> _.mapObject @clientShema, (value, key) -> value.init
    watch:
      clientId: ->
        @loadClient()
      editMode: (val) ->
        @client = $.extend(true, {}, @clientOriginal) unless val
    methods:
      initializeClient: -> @client = $.extend(true, {}, @clientInit)
      loadClient: ->
        $.ajax "/api/clients/#{@clientId}.json"
          .done (response) =>
            @clientOriginal = response
            @client = $.extend(true, {}, @clientOriginal)
          .fail (response) =>
            console.error response
      submit: ->
        try
          submit = $('.client_show__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/clients/#{@clientId}.json"
            type: 'PATCH'
            data:
              client:
                cd:               @client.cd
                company_name:     @client.company_name
                department_name:  @client.department_name
                address:          @client.address
                zip_code:         @client.zip_code
                phone_number:     @client.phone_number
                memo:             @client.memo
          .done (response) =>
            toastr.success('', response.message)
            @loadClient()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
    created: -> @initializeClient()
