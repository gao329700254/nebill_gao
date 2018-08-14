$ ->
  Vue.component 'userList',
    template: '#user_list'
    data: ->
      users: []
      sortKey: 'id'
      roles: []
    methods:
      loadUsers: ->
        $.ajax '/api/users.json'
          .done (response) =>
            @users = response
      loadRoles: ->
        $.ajax '/api/users/roles.json'
          .done (response) =>
            @roles = response
      linkToShow: (userId) -> window.location = "/admin/users/#{userId}/show"
      showUserNew: -> @$broadcast('showUserNewEvent')
    compiled: ->
      @loadUsers()
      @loadRoles()
    events:
      loadUsersEvent: -> @loadUsers()
