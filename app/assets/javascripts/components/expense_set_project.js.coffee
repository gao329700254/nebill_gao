$ ->
  Vue.component 'expenseSetProject',
    template: '#expense_set_project'
    mixins: [Vue.modules.modal]
    props: ['def']
    data: ->
      selectSchema:
        cd: 'eq'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
      contractStatus: []
      start: undefined
      end: undefined
      progressProject: false
      today: new Date()
      finishedStatus: undefined
      postDate : undefined
      unprocessedProject : undefined
      ids: undefined
    watch:
      progressProject: (val) ->
        if val == true
          @postDate = @today.getFullYear() + '-' + ( @today.getMonth() + 1 ) + '-' + @today.getDate()
        else
          @postDate = undefined
        @search()
      unprocessedProject: (val) ->
        if val == true
          @unprocessedProject = true
        else
          @unprocessedProject = undefined
        @search()
    methods:
      changeRadio: (projectId) -> @ids = projectId
      search: ->
        try
          search = $('.project_list__search__date__btn--search')
          search.prop('disabled', true)
          $.ajax
            url: '/api/projects/search_result.json'
            type: 'POST'
            data: {
              start: @start
              end: @end
              today: @postDate
              unprocessed: @unprocessedProject
            }
          .done (response) =>
            @list = response
        finally
          search.prop('disabled', false)
      setProject: ->
        @modalHide()
        @$dispatch('loadProject', @ids)
    compiled: ->
      @search()
    events:
      showExpenseNewEvent: -> @modalShow()
