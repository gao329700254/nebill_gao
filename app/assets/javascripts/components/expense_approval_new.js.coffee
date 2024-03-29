$ ->
  Vue.component 'expenseApprovalNew',
    template: '#expense_approval_new'
    mixins: [Vue.modules.modal]
    props: ['ids', 'list']
    data: ->
      notes:           ''
      total_amount:    0
      selected:        []
      status:          ''
      created_user_id: ''
      allUsers:        []
      current_user:    ''
    methods:
      cancel: -> @modalHide()
      submit: ->
        @total_amount = 0
        @selected = []
        if @status != ''
          if @ids.length != 0
            @selected = @ids
            for i in @list
              if @ids.includes(i.id)
                @total_amount = parseInt(@total_amount) + parseInt(i.amount)
          else
            @modalHide()
        else
          for i in @list
            @selected.push(i.id)
            @total_amount = parseInt(@total_amount) + parseInt(i.amount)
        try
          submit = $('.expense_approval_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/expenses/create_expense_approval.json'
            type: 'POST'
            data:
              notes: @notes
              total_amount: @total_amount
              selected: @selected
              created_user_id: @created_user_id
          .done (response) =>
            toastr.success('', response.message)
            @modalHide()
            @ids = []
            @$dispatch('loadExpenseList')
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
      loadAllUsers: ->
        $.ajax '/api/users.json'
          .done (response) =>
            @allUsers
            response.forEach (element) =>
              @allUsers.push(element)
        @current_user = @created_user_id
      onItemChange: ->
        @created_user_id = @current_user
    events:
      showExpenseApprovalNewEvent: ->
        @modalShow()
        @loadAllUsers()
        $('.expense_approval_new__form__submit_btn').prop('disabled', false)
