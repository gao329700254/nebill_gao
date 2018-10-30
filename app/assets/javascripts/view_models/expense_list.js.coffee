$ ->
  window.expenseList = new Vue
    el: '#expense_list'
    data:
      sortKey: 'id'
      selectedApproval: '0'
      selectSchema:
        name: 'like'
        created_user_name: 'like'
      list: undefined
      expense_approval:
        approval_list: undefined
        status: undefined
      total: undefined
      status: undefined
      created_at: undefined
      ids: []
      isCheckAll: false
      url: undefined
      eappr: undefined
      ability:
        show_expense_approval_new: undefined
        reapproval: undefined
        show_expense_new: undefined
        add_expense_new: undefined
        destroy: undefined
        invalid_approval: undefined
    methods:
      linkToShow: (expenseId, updateFlug) ->
        if updateFlug
          window.location = "/expense/#{expenseId}/edit"
      showExpenseNew: ->
        if @selectedApproval == '0'
          window.location = '/expense/new'
        else
          window.location = "/expense/new?selectedApproval=#{@selectedApproval}"
      showExpenseApprovalNew: -> @$broadcast('showExpenseApprovalNewEvent')
      checkAll: ->
        @isCheckAll = !@isCheckAll
        @ids = []
        if @isCheckAll
          for i in @list
            @ids.push(i.id)
      updateCheckAll: ->
        if @ids.length == @list.length
          @isCheckAll = true
        else
          @isCheckAll = false
      showExpenseFile: (element) ->
        @url = element.url
        if element.url.includes('.pdf')
          window.open(element)
        else
          @$broadcast('showExpenseFileEvent')
      loadChoiceExpenseApproval: ->
        $.ajax
          url: '/api/expenses/load_list.json'
          type: 'POST'
          data:
            selectedApproval: gon.selectedApproval || @selectedApproval || 0
        .done (response) =>
          @list = response.list
          @total = response.total
          @expense_approval.status = response.expense_approval.status
          @selectedApproval = response.expense_approval.id
          @eappr = response.eappr
          @ability = response.ability
      destroy: ->
        try
          destroy = $('.expense_list__btn--delete')
          destroy.prop('disabled', true)
          if(@ids.length > 0 && confirm($('#header__delete_confirm_message').val()))
            $.each @ids, (i, expense) =>
              $.ajax
                url: "/api/expenses/#{expense}.json"
                type: 'DELETE'
              .done (response) =>
                location.reload(true)
              .fail (response) =>
                json = response.responseJSON
                if _.has(json, 'errors')
                  toastr.error(json.errors.full_messages.join('<br>'), json.message)
                else
                  toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      Reapproval: ->
        if(confirm($('#header__reapproval_confirm_message').val()))
          $.ajax
            url: '/api/expenses/reapproval.json'
            type: 'POST'
            data:
              selectedApproval: @selectedApproval || 0
          .done (response) =>
            location.reload(true)
      InvalidApproval: ->
        if(confirm($('#header__invalid_confirm_message').val()))
          $.ajax
            url: '/api/expenses/invalid_approval.json'
            type: 'POST'
            data:
              selectedApproval: @selectedApproval || 0
          .done (response) =>
            location.reload(true)
    compiled: ->
      $.ajax '/api/expenses.json'
      .done (response) =>
        @expense_approval.approval_list = response.expense_approval.approval_list
      @loadChoiceExpenseApproval()
      gon.selectedApproval = false
