$ ->
  Vue.component 'userMemberList',
    template: '#user_member_list'
    props: ['projectId']
    data: ->
      users: []
    methods:
      loadUsers: ->
        $.ajax "/api/projects/#{@projectId}/users"
          .done (response) =>
            @users = response
    compiled: ->
      @loadUsers()
