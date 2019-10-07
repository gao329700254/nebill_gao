$ ->
  Vue.component 'expenseNew',
    template: '#expense_new'
    mixins: [Vue.modules.modal]
    props: ['ids']
    data: ->
      image: ''
      file_input: undefined
      delete: ''
      default_id: ''
      expense_approval_id: ''
      defaule_expense_items:
        display_name: ''
        is_routing: ''
        is_quntity: ''
        standard_amount: ''
        is_receipt: ''
      selected: ''
      defaultIds: []
      expense:
        payment_type: 'person_rebuilding'
        use_date: new Date().toISOString().substr(0, 10)
        depatture_location: ''
        arrival_location: ''
        notes: ''
      fix_amount: ''
      arrow: '→'
      checked: false
      selected_project: ''
      project_list: []
      files: []
      return:
        expense:
          depatture_location: ''
          arrival_location: ''
        defaule_expense_items:
          standard_amount: ''
    methods:
      cancel: ->
        @modalHide()
      submit: (e) ->
        try
          submit = $('.expense_new__form__btn--submit')
          submit.prop('disabled', true)
          form = new FormData()
          form.append('expense[file_attributes][file]', @files[0]) if @image
          form.append('expense[use_date]', @expense.use_date)
          form.append('expense[expense_approval_id]', @expense_approval_id)
          form.append('expense[default_id]', @expense.default_id)
          if @defaule_expense_items.is_routing
            form.append('expense[depatture_location]', @expense.depatture_location)
            form.append('expense[is_round_trip]', @checked)
            form.append('expense[arrival_location]', @expense.arrival_location)
          form.append('expense[amount]', @defaule_expense_items.standard_amount)
          form.append('expense[payment_type]', @expense.payment_type)
          form.append('expense[project_id]', @selected_project) if @selected_project
          form.append('expense[notes]', @expense.notes)
          form.append('fix_amount', @fix_amount)
          $.ajax
            url: '/api/expenses.json'
            type: 'POST'
            data: form
            cache: false
            contentType: false
            processData: false
          .done (response) =>
            toastr.success('', response.message)
            @$dispatch('loadExpenseList')
            @expense.notes = ''
            if @file_input
              @file_input.value = ''
              @image = ''
            if e == 1
              @expense = _.mapObject @expense, (v, k) -> undefined
              @expense.use_date = new Date().toISOString().substr(0, 10)
              @defaule_expense_items = _.mapObject @defaule_expense_items, (v, k) -> undefined
              @selected_project = ''
              @modalHide()
              @.$parent.modalHide()
            else
              submit.prop('disabled', false)
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      loadExpense: ->
        if @ids
          $.ajax
            url: '/api/expenses/load_expense.json'
            type: 'POST'
            data: {
              expense_id: @ids
            }
          .done (response) =>
            @expense = response
            @expense.notes = ''
            if @expense.default_id
              @onItemChange()
            if @expense.project_id
              @setProject(@expense.project_id)
            @image = ''
          .fail (response) =>
            @expense = ''
      loadDefaultIds: ->
        $.ajax '/api/expenses/set_default_items.json'
          .done (response) =>
            @defaultIds
            response.forEach (element) =>
              @defaultIds.push(element)
      onFileChange: (e) ->
        @file_input = e.target
        @files = @file_input.files
        @createImage @files[0]
      createImage: (file) ->
        image = new Image()
        reader = new FileReader()
        vm = @
        reader.onload = (e) ->
          vm.image = e.target.result
        reader.readAsDataURL file
      onItemChange: ->
        try
          $.ajax
            url: '/api/expenses/input_item.json'
            type: 'POST'
            data: {
              defaule_expense_items: @expense.default_id
            }
          .done (response) =>
            @defaule_expense_items = response
            if @expense.amount
              @defaule_expense_items.standard_amount = @expense.amount
              @expense.amount = 0
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
      setProjectModal: -> @$broadcast('showExpenseNewEvent')
      showExpenseTransportation: -> @$broadcast('showExpenseTransportationEvent')
    events:
      showExpenseNewEvent: (val) ->
        @modalShow()
        @expense_approval_id = val
        @loadExpense()
      loadProject: (projectId) -> @setProject(projectId)
    compiled: ->
      @loadDefaultIds()
