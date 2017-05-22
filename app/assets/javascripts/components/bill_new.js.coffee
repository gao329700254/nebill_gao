$ ->
  Vue.component 'billNew',
    template: '#bill_new'
    props: ['projectId']
    data: ->
      bill:
        cd: undefined
        amount:         undefined
        delivery_on:    undefined
        acceptance_on:  undefined
        payment_type:   undefined
        bill_on:        undefined
        deposit_on:     undefined
        memo:           undefined
      default_amount: undefined
    methods:
      submit: ->
        try
          submit = $('.bill_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/projects/#{@projectId}/bills.json"
            type: 'POST'
            data: { bill: @bill }
          .done (response) =>
            toastr.success('', response.message)
            @initializeBill()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
      initializeBill: ->
        @bill.cd = undefined
        @bill.amount        = @default_amount
        @bill.delivery_on   = undefined
        @bill.acceptance_on = undefined
        @bill.payment_type  = undefined
        @bill.bill_on       = undefined
        @bill.deposit_on    = undefined
        @bill.memo          = undefined
    created: ->
      $.ajax "/api/projects/#{@projectId}/default_dates.json"
        .done (response) =>
          @bill.delivery_on   = response.delivery_on
          @bill.acceptance_on = response.acceptance_on
          @bill.payment_type  = response.payment_type
          @bill.bill_on       = response.bill_on
          @bill.deposit_on    = response.deposit_on
        .fail (response) =>
          console.error response
