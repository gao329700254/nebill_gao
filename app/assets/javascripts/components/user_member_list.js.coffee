$ ->
  Vue.component 'userMemberList',
    template: '#user_member_list'
    props: ['projectId']
    data: ->
      members: []
      users: []
      allUsers: []
      selectedMemberId: undefined
    computed:
      selectedUsers: -> _.filter @users, (u) -> u.selected
      selectableUsers: ->
        ids = _.pluck(@users, 'employee_id')
        _.reject @allUsers, (p) ->
          _.includes(ids, p.id)
    methods:
      loadMemberPartner: ->
        $.ajax
          url: "/api/projects/#{@projectId}/member_partner.json"
          type: 'POST'
          data: { type: 'UserMember' }
        .done (response) =>
          @users = response
      loadPartnersUsers: ->
        @allUsers = []
        $.ajax '/api/projects/load_partner_user.json'
          .done (response) =>
            response.forEach (emp) =>
              if emp.actable_type == 'User'
                @allUsers.push(emp)
      addUserMember: ->
        return unless @selectedMemberId?
        try
          submit = $('.user_member_list__tbl__user_btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/user_members/#{@projectId}/#{@selectedMemberId}.json"
            type: 'POST'
          .done (response) =>
            @selectedMemberId = undefined
            toastr.success('', response.message)
            @loadMemberPartner()
            @loadPartnersUsers()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      deleteUserMember: ->
        try
          destroy = $('.user_member_list__tbl__btn')
          destroy.prop('disabled', true)
          $.each @selectedUsers, (i, user) =>
            $.ajax
              url: "/api/user_members/#{@projectId}/#{user.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadMemberPartner()
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
          @loadPartnersUsers()
        finally
          destroy.prop('disabled', false)
    created: ->
      @loadMemberPartner()
      @loadPartnersUsers()
