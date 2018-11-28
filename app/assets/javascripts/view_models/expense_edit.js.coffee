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
      arrow: '→'
      checked: false
      selected_project: ''
      project_list: []
    methods:
      setProjectModal: -> @$broadcast('showExpenseNewEvent')
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
      onArrowChange: (e) ->
        if @defaule_expense_items.standard_amount　> 0
          if e
            @arrow = '↔️'
            @defaule_expense_items.standard_amount *= 2
          else
            @arrow = '→'
            @defaule_expense_items.standard_amount /= 2
        else
          @checked = !@checked
          @defaule_expense_items.standard_amount = 0
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
      checkRoundTrip: ->
        if gon.is_round_trip
          @arrow = '↔️'
        else
          @arrow = '→'
      
      setProject: (e) ->
        try
          $.ajax
            url: '/api/expenses/set_project.json'
            type: 'POST'
            data: {
              project_id: e
            }
          .done (response) =>
            @project_list.push(response)
            @selected_project = response.id
    ready: ->
      @loadDefaultExpenseItem()
      @checkRoundTrip()
      if gon.project
        @setProject(gon.project)
    events:
      loadProject: (projectId) -> @setProject(projectId)
