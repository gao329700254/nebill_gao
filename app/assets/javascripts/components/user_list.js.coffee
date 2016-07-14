$ ->
  Vue.component 'userList',
    template: '#user_list'
    data: ->
      users: []
      sortKey: 'id'
    methods:
      loadUsers: ->
        $.ajax '/api/users.json'
          .done (response) =>
            @users = response
    events:
      loadUsersEvent: -> @loadUsers()
    compiled: ->
      @loadUsers()
