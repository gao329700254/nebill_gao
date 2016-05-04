$ ->
  Vue.component 'billNew',
    template: '#bill_new'
    props: ['projectId']
    data: ->
      bill:
        key: undefined
        delivery_on:    undefined
        acceptance_on:  undefined
        payment_on:     undefined
        bill_on:        undefined
        deposit_on:     undefined
        memo:           undefined
    methods:
      submit: ->
        try
          submit = $('.bill_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/projects/#{@projectId}/bills.json"
            type: 'POST'
            data: {bill: @bill}
          .done (response) =>
            toastr.success('', response.message)
            @initializeBill()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
      initializeBill: ->
        @bill.key = undefined
        @bill.delivery_on   = undefined
        @bill.acceptance_on = undefined
        @bill.payment_on    = undefined
        @bill.bill_on       = undefined
        @bill.deposit_on    = undefined
        @bill.memo          = undefined
