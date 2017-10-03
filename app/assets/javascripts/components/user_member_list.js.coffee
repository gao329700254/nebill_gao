$ ->
  Vue.component 'userMemberList',
    template: '#user_member_list'
    props: ['projectId']
    data: ->
      users: []
      allUsers: []
      selectedUserId: undefined
      project:
        status: undefined
    computed:
      selectableUsers: ->
        ids = _.pluck(@users, 'id')
        _.reject @allUsers, (p) ->
          _.includes(ids, p.id)
      selectedUsers: -> _.filter @users, (u) -> u.selected
    methods:
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @project = response
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
            @$dispatch('addMemberEvent')
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      deleteMember: ->
        try
          destroy = $('.user_member_list__delete_member--btn')
          destroy.prop('disabled', true)
          $.each @selectedUsers, (i, user) =>
            $.ajax
              url: "/api/user_members/#{@projectId}/#{user.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadUsers()
              @loadAllUsers()
              @$dispatch('deleteMemberEvent')
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
    events:
      loadProjectEvent: ->
        @loadProject()
    compiled: ->
      @loadUsers()
      @loadAllUsers()
      @loadProject()
