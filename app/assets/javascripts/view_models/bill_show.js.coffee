$ ->
  # HACK(hishida): projectDetailと共通化
  window.billShow = new Vue
    el: '#bill_show'
    data:
      billId: undefined
      billSchema:
        id:             {init: ''}
        project_id:     {init: ''}
        key:            {init: ''}
        delivery_on:    {init: ''}
        acceptance_on:  {init: ''}
        payment_on:     {init: ''}
        bill_on:        {init: ''}
        deposit_on:     {init: ''}
        created_at:     {init: ''}
        updated_at:     {init: ''}
      editMode: false
      bill: undefined
      billOriginal: undefined
    computed:
      billInit: -> _.mapObject @billSchema, (value, key) -> value.init
    watch:
      billId: ->
        @loadBill()
      editMode: (val) ->
        @bill = $.extend(true, {}, @billOriginal) unless val
    methods:
      initializeBill: -> @bill = $.extend(true, {}, @billInit)
      loadBill: ->
        $.ajax "/api/bills/#{@billId}.json"
          .done (response) =>
            @billOriginal = response
            @bill = $.extend(true, {}, @billOriginal)
          .fail (response) =>
            console.error response
      submit: ->
        try
          submit = $('.bill_show__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/bills/#{@billId}.json"
            type: 'PATCH'
            data:
              bill:
                key:            @bill.key
                delivery_on:    @bill.delivery_on
                acceptance_on:  @bill.acceptance_on
                payment_on:     @bill.payment_on
                bill_on:        @bill.bill_on
                deposit_on:     @bill.deposit_on
                memo:           @bill.memo
          .done (response) =>
            toastr.success('', response.message)
            @loadBill()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
    created: -> @initializeBill()
