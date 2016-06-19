$ ->
  window.projectShow = new Vue
    el: '#project_show'
    data:
      projectId: undefined
      currentView: 'projectDetail'
    methods:
      viewShow: (view) ->
        page.show view

  page hashbang: true, dispatch: false
  page 'project_detail', (ctx) ->
    projectShow.currentView = 'projectDetail'
  page 'bill_new', (ctx) ->
    projectShow.currentView = 'billNew'
  page 'member_list', (ctx) ->
    projectShow.currentView = 'memberList'
