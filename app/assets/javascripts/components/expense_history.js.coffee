$ ->
  Vue.component 'expenseHistory',
    template: '#expense_history'
    mixins: [Vue.modules.modal]
    props: ['def']
    data: ->
      selectSchema:
        default_id: 'eq'
      list: undefined
      defaultIds: []
      id: undefined
      station: undefined
      note: undefined
      ids: undefined
    methods:
      loadDefaultIds: ->
        $.ajax '/api/expenses/set_default_items.json'
          .done (response) =>
            @defaultIds
            response.forEach (element) =>
              @defaultIds.push(element)
      loadHistory: ->
        $.ajax
          url:  '/api/expenses/expense_history.json'
          type: 'POST'
          data:
            station: @station
            note: @note
        .done (response) =>
          @list = response.list
      searchHistory: ->
        try
          search = $('.expense_history__search__item__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/expenses/expense_history.json'
            type: 'POST'
            data:
              station: @station
              note: @note
          .done (response) =>
            @list = response.list
        finally
          search.prop('disabled', false)
      showExpenseModalNew: ->
        if @ids
          window.location = "/expense/new?expense_id=#{@ids}"
        else
          window.location = '/expense/new'
    compiled: ->
      @loadHistory()
      @loadDefaultIds()
    events:
      showExpenseHistoryEvent: -> @modalShow()