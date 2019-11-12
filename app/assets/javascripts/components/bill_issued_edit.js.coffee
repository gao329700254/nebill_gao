$ ->
  Vue.component 'billIssuedEdit',
    template: '#bill_issueds_edit'
    mixins: [Vue.modules.modal]
    data: ->
      bill:
        project_id:             ''
        cd:                     ''
        amount:                 ''
        delivery_on:            ''
        acceptance_on:          ''
        payment_type:           ''
        bill_on:                ''
        expected_deposit_on:    ''
        deposit_on:             ''
        memo:                   ''
        status:                 ''
    methods:
      cancel: -> @modalHide()
      # submit: ->
    events:
      showBillIssuedEditEvent: -> 
        console.log('イベントに入った')
        @modalShow()

