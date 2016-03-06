$ ->
  Vue.component 'projectGroupsItem',
    template: '#project_groups__item'
    props: ['projectGroupId', 'projectGroupName']
    data: ->
      projectList: undefined
    methods:
      load: ->
        groupId = if String(@projectGroupId) == '0' then null else @projectGroupId
        $.ajax
          url: '/api/projects.json'
          data: {group_id: groupId}
        .done (response) =>
          @projectList = response
      setSortable: ->
        new Sortable document.getElementById("project_groups__sortable-#{@projectGroupId}"),
          group: 'group'
          sort: false
          chosenClass: 'project_groups__item__project_body__item--chosen'
          animation: 150
          onAdd: (evt) => @moveProject(evt)
      moveProject: (evt) ->
        projectId = evt.item.id.match(/project-([0-9]+)/)[1]
        toProjectGroupId = evt.to.id.match(/project_groups__sortable-([0-9]+)/)[1]
        groupId = if String(toProjectGroupId) == '0' then null else toProjectGroupId
        $.ajax
          url: "/api/projects/#{projectId}.json"
          type: 'PATCH'
          data:
            project: {group_id: groupId}
        .done (response) =>
          toastr.success('', response.message)
    ready: ->
      @load()
      @setSortable()
