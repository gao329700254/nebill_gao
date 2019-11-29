$ ->
  Vue.component 'billIssuedEdit',
    template: '#bill_issueds_edit'
    mixins: [Vue.modules.modal]
    data: ->
      billId: undefined
      sortKey: 'cd'
      list: undefined
      buttonText: '未確認'
      bill_id: ''
      bill: ''
      billOriginal: undefined
      project: ''
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
      loadProject: ->
        $.ajax "/api/projects/bill/#{@bill_id}.json"
          .done (response) =>
            @project = response
      submit: (bill) ->
        try
          $.ajax
            url: "/api/bill_issueds/#{@bill_id}.json"
            type: 'PATCH'
            data: {
              bill: {
                status: 'confirmed'
                deposit_on: bill.deposit_on
                deposit_confirmed_memo: bill.deposit_confirmed_memo
              }
            }
          .done (response) =>
            toastr.success('', response.message)
            @loadBillIssued(@bill_id)
            @modalHide()
            location.reload()
          .fail (response) =>
            json = response.responseJSON
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
    events:
      showBillIssuedEditEvent: (bill) ->
        @modalShow()
        @bill_id = bill.id
        @loadBillIssued()
        @loadProject()
