$ ->
  window.projectList = new Vue
    el:  '#project_list'
    data:
      selectSchema:
        cd: 'like'
        name: 'like'
        orderer_company_name: 'like'
      list: undefined
      searchKeywords: undefined
      contractStatus: []
      projectStatus: []
      start: undefined
      end: undefined
    methods:
      linkToShow: (projectId) -> window.location = "/projects/#{projectId}/show"
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
            }
          .done (response) =>
            @list = @reverseList(response)
        finally
          search.prop('disabled', false)
      reverseList: (list) ->
        compareUpdatedAt = (a, b) ->
          if b.updated_at >= a.updated_at then 1 else -1
        sortedList = list.slice().sort(compareUpdatedAt)
      download: ->
        formData = new FormData()
        formData.append('status', @projectStatus)
        formData.append('contract_status', @contractStatus)
        formData.append('start', @start)
        formData.append('end', @end)

        req = new XMLHttpRequest()
        req.open('GET', '/projects/csv', true)
        req.responseType = "blob"

        req.onload = (event) =>
          blob = req.response
          link = document.createElement('a')
          downloadUrl  = window.URL.createObjectURL(blob)
          link.href = downloadUrl
          link.download = 'projects.csv'
          link.click()
          window.URL.revokeObjectURL(downloadUrl)

        req.send(formData)
    compiled: ->
      @search()
    events:
      loadSearchEvent: ->
        @search()
