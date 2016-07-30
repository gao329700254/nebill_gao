$ ->
  Vue.component 'billNew',
    template: '#bill_new'
    props: ['projectId']
    data: ->
      bill:
        key: undefined
        amount:         undefined
        delivery_on:    undefined
        acceptance_on:  undefined
        payment_on:     undefined
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
        @bill.key = undefined
        @bill.amount        = @default_amount
        @bill.delivery_on   = undefined
        @bill.acceptance_on = undefined
        @bill.payment_on    = undefined
        @bill.bill_on       = undefined
        @bill.deposit_on    = undefined
        @bill.memo          = undefined
    created: ->
      $.ajax "/api/projects/#{@projectId}/default_dates.json"
        .done (response) =>
          @bill.delivery_on   = response.delivery_on
          @bill.acceptance_on = response.acceptance_on
          @bill.payment_on    = response.payment_on
          @bill.bill_on       = response.bill_on
          @bill.deposit_on    = response.deposit_on
        .fail (response) =>
          console.error response
