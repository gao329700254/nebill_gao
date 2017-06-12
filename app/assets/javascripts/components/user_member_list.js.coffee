$ ->
  Vue.component 'userMemberList',
    template: '#user_member_list'
    props: ['projectId']
    data: ->
      users: []
      allUsers: []
      selectedUserId: undefined
    computed:
      selectableUsers: ->
        ids = _.pluck(@users, 'id')
        _.reject @allUsers, (p) ->
          _.includes(ids, p.id)
    methods:
      loadUsers: ->
        $.ajax "/api/projects/#{@projectId}/users"
          .done (response) =>
            @users = response
      loadAllUsers: ->
        $.ajax '/api/users'
          .done (response) =>
            @allUsers = response
      addMember: ->
        return unless @selectedUserId?
        try
          submit = $('.user_member_list__new_member__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/user_members/#{@projectId}/#{@selectedUserId}.json"
            type: 'POST'
          .done (response) =>
            toastr.success('', response.message)
            @selectedUserId = undefined
            @loadUsers()
            @loadAllUsers()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
    compiled: ->
      @loadUsers()
      @loadAllUsers()
