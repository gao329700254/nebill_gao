$ ->
  # HACK(hishida): projectDetailと共通化
  window.billShow = new Vue
    el: '#bill_show'
    data:
      billId: undefined
      billSchema:
        id:                  { init: '' }
        project_id:          { init: '' }
        cd:                  { init: '' }
        amount:              { init: '' }
        delivery_on:         { init: '' }
        acceptance_on:       { init: '' }
        payment_type:        { init: '' }
        bill_on:             { init: '' }
        expected_deposit_on: { init: '' }
        deposit_on:          { init: '' }
        created_at:          { init: '' }
        updated_at:          { init: '' }
      editMode: false
      bill: undefined
      billOriginal: undefined
      project: []
    computed:
      billInit: -> _.mapObject @billSchema, (value, key) -> value.init
    watch:
      billId: ->
        @loadBill()
        @loadProject()
      editMode: (val) ->
        @bill = $.extend(true, {}, @billOriginal) unless val
    methods:
      initializeBill: ->
        @bill = $.extend(true, {}, @billInit)
      loadBill: ->
        $.ajax "/api/bills/#{@billId}.json"
          .done (response) =>
            @billOriginal = response
            @bill = $.extend(true, {}, @billOriginal)
          .fail (response) =>
            console.error response
      loadProject: ->
        $.ajax "/api/projects/bill/#{@billId}.json"
          .done (response) =>
            @project = response
      submit: ->
        try
          submit = $('.bill_show__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/bills/#{@billId}.json"
            type: 'PATCH'
            data:
              bill:
                cd:                  @bill.cd
                amount:              @bill.amount
                delivery_on:         @bill.delivery_on
                acceptance_on:       @bill.acceptance_on
                payment_type:        @bill.payment_type
                bill_on:             @bill.bill_on
                expected_deposit_on: @bill.expected_deposit_on
                deposit_on:          @bill.deposit_on
                memo:                @bill.memo
          .done (response) =>
            toastr.success('', response.message)
            @loadBill()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.bill_show__form__btn--delete')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/bills/#{@billId}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/bills/list'
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
    created: -> @initializeBill()
    events:
      loadProjectEvent: ->
        @loadProject()
