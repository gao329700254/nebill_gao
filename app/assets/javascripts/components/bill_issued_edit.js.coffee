$ ->
  Vue.component 'billIssuedEdit',
    template: '#bill_issueds_edit'
    mixins: [Vue.modules.modal]
    data: ->
      sortKey: 'cd'
      list: undefined
      buttonText: '未確認'
      bill_id: ''
    methods:
      cancel: -> @modalHide()
      loadBillIssued: ->
        $.ajax 
          url: "/api/bill_issueds/#{@bill_id}.json"
        .done (response) =>
          @billOriginal = response
          @bill = $.extend(true, {}, @billOriginal)
        .fail (response) =>
          console.error response
      # submit: (bill) ->
      #   try
      #     $.ajax
      #       url: "/api/bill_issueds/#{bill.id}.json"
      #       type: 'PATCH'
      #       data: {
      #         bill: {
      #           memo: bill.memo
      #         }
      #       }
      #     .done (response) =>
      #       toastr.success('', response.message)
      #       @loadBillIssued(bill.id)
      #       # window.location = "/bills/#{bill.id}/show"
      #     .fail (response) =>
      #       json = response.responseJSON
      #       if _.has(json, 'errors')
      #         toastr.error(json.errors.full_messages.join('<br>'), json.message)
      #       else
      #         toastr.error('', json.message)
    events:
      showBillIssuedEditEvent: (bill) -> 
        @modalShow()
        @bill_id = bill.id
        console.log(@bill_id)
        @loadBillIssued()

