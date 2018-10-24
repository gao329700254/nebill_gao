$ ->
  window.expenseCsv = new Vue
    el: '#expense_csv'
    data:
      start: undefined
      end: undefined
      csv: undefined
      expense_approval: undefined
    methods:
      search: ->
        try
          search = $('.expense_csv__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/expenses/search_for_csv.json'
            type: 'POST'
            data: {
              start: @start
              end: @end
            }
          .done (response) =>
            @csv = response
        finally
          search.prop('disabled', false)
