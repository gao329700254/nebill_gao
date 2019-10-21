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
      selected_employee_project: @employee_project_list
      employee_project_list: []
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
        if e
          @arrow = '↔️'
        else
          @arrow = '→'
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
      setExpenseProjectId: ->
        @expenseProjectId = $('#expense_project_id').val()
      checkRoundTrip: ->
        if gon.is_round_trip
          @arrow = '↔️'
        else
          @arrow = '→'
      employeeLoadProjects: (e) ->
        $.ajax
          url: '/api/expenses/employee_load_projects.json'
          type: 'POST'
          data: {
            project_id: e
          }
        .done (response) =>
          @employee_project_list = response
      setProject: (e) ->
        try
          $.ajax
            url: '/api/expenses/set_project.json'
            type: 'POST'
            data: {
              project_id: e
            }
          .done (response) =>
            @employee_project_list.push(response)
            @employee_project_list = _.uniq(@employee_project_list, 'cd')
            @selected_employee_project = response.id
    ready: ->
      @loadDefaultExpenseItem()
      @employeeLoadProjects()
      @checkRoundTrip()
      if gon.project
        @setProject(gon.project)
    events:
      loadProject: (projectId) -> @setProject(projectId)
