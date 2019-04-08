$ ->
  Vue.component 'agreementProjectList',
    template: '#agreement_project_list'
    data: ->
      list: []
    methods:
      loadList: ->
        $.ajax '/api/agreements/project_list.json'
          .done (response) =>
            @list = response
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
    compiled: ->
      @loadList()
