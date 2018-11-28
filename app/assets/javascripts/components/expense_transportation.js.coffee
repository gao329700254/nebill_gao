$ ->
  Vue.component 'expenseTransportation',
    template: '#expense_transportation'
    mixins: [Vue.modules.modal]
    props: ['departure', 'arrival']
    data: ->
      list: undefined
      arrow: '→'
      id_tr: undefined
    methods:
      changeRadio: (transportationId) -> @id_tr = transportationId
      searchTransportation: ->
        try
          search = $('.expense_transportation__search__item__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/expenses/expense_transportation.json'
            type: 'POST'
            data:
              departure: @departure
              arrival: @arrival
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
      cancel: -> @modalHide()
      add_value: ->
        for i in @list
          if i.id == @id_tr
            @.$parent.departure = i.departure
            @.$parent.arrival = i.arrival
            @.$parent.defaule_expense_items.standard_amount = i.amount
        @modalHide()
    events:
      showExpenseTransportationEvent: ->
        @modalShow()
        @searchTransportation()
