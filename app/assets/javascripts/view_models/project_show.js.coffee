$ ->
  window.projectShow = new Vue
    el: '#project_show'
    data:
      projectId: undefined
      currentView: 'projectDetail'
    methods:
      viewShow: (view) ->
        page.show view
      loadStatus: ->
        @$broadcast('loadStatusEvent')
      loadProject: ->
        @$broadcast('loadProjectEvent')
    events:
      createBillEvent: -> @loadStatus()
      updateProjectEvent: -> @loadProject()

  page hashbang: true, dispatch: false
  page 'project_detail', (ctx) ->
    projectShow.currentView = 'projectDetail'
  page 'project_bill_list', (ctx) ->
    projectShow.currentView = 'projectBillList'
  page 'member_list', (ctx) ->
    projectShow.currentView = 'memberList'
  page 'files', (ctx) ->
    projectShow.currentView = 'files'
