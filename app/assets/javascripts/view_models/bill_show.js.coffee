$ ->
  # HACK(hishida): projectDetailと共通化
  window.billShow = new Vue
    el: '#bill_show'
    data:
      billId: undefined
      billSchema:
        id:                  { init: '' }
        cd:                  { init: '' }
        project_name:        { init: '' }
        company_name:        { init: '' }
        amount:              { init: '' }
        delivery_on:         { init: '' }
        acceptance_on:       { init: '' }
        payment_type:        { init: '' }
        bill_on:             { init: '' }
        issue_on:            { init: '' }
        expected_deposit_on: { init: '' }
        deposit_on:          { init: '' }
        status:              { init: '' }
        expense:             { init: '' }
        require_acceptance:  { init: '' }
        created_at:          { init: '' }
        updated_at:          { init: '' }
      editMode: false
      editDetail: false
      bill: undefined
      billOriginal: undefined
      project: []
      details: []
      detailsOriginal: []
      taxRate: 0.1
    computed:
      billInit: ->
        _.mapObject @billSchema, (value, key) -> value.init
      checkIntegration: ->
        parseInt(@bill.amount) == @subtotalAmount
      subtotalAmount: ->
        amountSum = _.map(@details, (detail) => @castDetailAmount(detail.amount))
        amountSum.reduce((total, amount) => total + amount)
      consumptionTax: ->
        Math.floor(@subtotalAmount * @taxRate)
      totalAmount: ->
        @subtotalAmount + @consumptionTax + parseInt(@bill.expense)
    watch:
      billId: ->
        @loadBill()
        @loadProject()
      editMode: (val) ->
        @bill = $.extend(true, {}, @billOriginal) unless val
      editDetail: (val) ->
        @details = $.extend(true, [], @detailsOriginal) unless val
    methods:
      initializeBill: ->
        @bill = $.extend(true, {}, @billInit)
      loadBill: ->
        $.ajax "/api/bills/#{@billId}.json"
          .done (response) =>
            @billOriginal    = response
            @detailsOriginal = response.details
            @bill    = $.extend(true, {}, @billOriginal)
            @details = $.extend(true, [], @detailsOriginal)
          .fail (response) =>
            console.error response
      loadProject: ->
        $.ajax "/api/projects/bill/#{@billId}.json"
          .done (response) =>
            @project = response
      castDetailAmount: (amount) ->
        if amount
          parseInt(amount)
        else
          0
      addColumn: (index) ->
        @details.push({content: '', amount: null})
      removeColumn: (index) ->
        @details.splice(index, 1)
      createDetails: ->
        submit = $('bill_show__form__btn--detail-update')
        submit.prop('disable', true)
        $.ajax
          url: "/api/bills/#{@billId}/bill_details"
          type: 'POST'
          data:
            details: @details
            expense: @bill.expense
        .done (response) =>
          toastr.success('', response.message)
          @loadBill()
          @editDetail = false
          submit.prop('disable', false)
        .fail (response) =>
          json = response.responseJSON
          if _.has(json, 'errors')
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
          else
            toastr.error('', json.message)
      submit: ->
        try
          submit = $('.bill_show__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/bills/#{@billId}.json"
            type: 'PATCH'
            data:
              bill:
                cd:                     @bill.cd
                project_name:           @bill.project_name
                company_name:           @bill.company_name
                amount:                 @bill.amount
                delivery_on:            @bill.delivery_on
                acceptance_on:          @bill.acceptance_on
                payment_type:           @bill.payment_type
                bill_on:                @bill.bill_on
                issue_on:               @bill.issue_on
                expected_deposit_on:    @bill.expected_deposit_on
                deposit_on:             @bill.deposit_on
                memo:                   @bill.memo
                deposit_confirmed_memo: @bill.deposit_confirmed_memo
                require_acceptance:     @bill.require_acceptance
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
      issue: ->
        $.ajax
          url: "/api/bills/#{@billId}.json"
          type: 'PATCH'
          data:
            bill:
              status: 'issued'
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
