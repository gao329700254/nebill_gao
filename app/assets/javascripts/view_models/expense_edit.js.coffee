$ ->
  window.expenseEdit = new Vue
    el: '#expense_edit'
    data: ->
      image: ''
      delete: ''
      default_id: ''
      defaule_expense_items:
        display_name: ''
        is_routing: ''
        is_quntity: ''
        standard_amount: ''
        is_receipt: ''

    methods:
      onFileChange: (e) ->
        files = e.target.files
        @createImage files[0]
      createImage: (file) ->
        image = new Image()
        reader = new FileReader()
        vm = @
        reader.onload = (e) ->
          vm.image = e.target.result
        reader.readAsDataURL file
      onItemChange: (e) ->
        try
          $.ajax
            url: '/api/expenses/input_item.json'
            type: 'POST'
            data: {
              defaule_expense_items: e
            }
          .done (response) =>
            @defaule_expense_items = response
      loadDefaultExpenseItem: (e) ->
        $.ajax
          url: '/api/expenses/load_item.json'
          type: 'POST'
          data: {
            expense_id: gon.expense_id
          }
        .done (response) =>
          @defaule_expense_items = response
          @defaule_expense_items.standard_amount = gon.amount
    ready: ->
      @loadDefaultExpenseItem()
