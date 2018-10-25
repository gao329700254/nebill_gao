$ ->
  window.expenseNew = new Vue
    el: '#expense_new'
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
      selected: ''
    methods:
      selectedName: ->
        if @selected
          @defaule_expense_items.is_routing = true
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
          search = e.target.value
          $.ajax
            url: '/api/expenses/input_item.json'
            type: 'POST'
            data: {
              defaule_expense_items: search
            }
          .done (response) =>
            @defaule_expense_items = response
            @image = ''
          .fail (response) =>
            @defaule_expense_items = ''
    compiled: ->
      @selectedName()
