$ ->
  window.projectShow = new Vue
    el: '#project_show'
    data:
      projectId: undefined
      currentView: 'projectDetail'
      lastUpdatedAt:
        updated_at: undefined
        whodunnit: undefined
    watch:
      projectId: ->
        @loadLastUpdatedAt()
    methods:
      loadLastUpdatedAt: ->
        $.ajax "/api/projects/#{@projectId}/last_updated_at.json"
          .done (response) =>
            @lastUpdatedAt = response
          .fail (response) =>
            console.error response
      viewShow: (view) ->
        page.show view
      loadStatus: ->
        @$broadcast('loadStatusEvent')
      loadProject: ->
        @$broadcast('loadProjectEvent')
    events:
      createBillEvent: -> @loadStatus()
      updateProjectEvent: ->
        @loadProject()
        @loadLastUpdatedAt()
      loadLastUpdatedAtEvent: -> @loadLastUpdatedAt()

  page hashbang: true, dispatch: false
  page 'project_detail', (ctx) ->
    projectShow.currentView = 'projectDetail'
  page 'project_bill_list', (ctx) ->
    projectShow.currentView = 'projectBillList'
  page 'member_list', (ctx) ->
    projectShow.currentView = 'memberList'
  page 'files', (ctx) ->
    projectShow.currentView = 'files'
