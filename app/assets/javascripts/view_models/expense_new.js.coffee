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
      fix_amount: ''
      arrow: '→'
      checked: false
      selected_project: ''
      project_list: []
      departure: ''
      arrival: ''
      return:
        departure: ''
        arrival: ''
        defaule_expense_items:
          standard_amount: ''
    methods:
      setProjectModal: -> @$broadcast('showExpenseNewEvent')
      selectedName: ->
        if @selected
          @onItemChange(@selected)
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
            if @fix_amount
              @defaule_expense_items.standard_amount = @fix_amount
              @fix_amount = 0
            @image = ''
          .fail (response) =>
            @defaule_expense_items = ''
      onArrowChange: (e) ->
        if e
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
      showExpenseTransportation: -> @$broadcast('showExpenseTransportationEvent')
    compiled: ->
      @selectedName()
    events:
      loadProject: (projectId) -> @setProject(projectId)
