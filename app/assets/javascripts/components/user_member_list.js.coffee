$ ->
  Vue.component 'userMemberList',
    template: '#user_member_list'
    props: ['projectId']
    data: ->
      members: []
      users: []
      allUsers: []
      selectedMemberId: undefined
      editMode: false
      failureMemberIds: []
      member:
        name: ''
        email: ''
        working_period_start: undefined
        working_period_end: undefined
        man_month: ''
    computed:
      selectedUsers: -> _.filter @users, (u) -> u.selected
      selectableUsers: ->
        ids = _.pluck(@users, 'employee_id')
        _.reject @allUsers, (p) ->
          _.includes(ids, p.id)
    methods:
      editModeOn: ->
        @editMode = true
        _.each @selectedUsers, (v, k) ->
          elems = document.getElementById('user-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = false
      editModeOff: ->
        @editMode = false
        @failureMemberIds = []
        _.each @users, (v, k) ->
          elems = document.getElementById('user-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = true
      loadMemberPartner: ->
        $.ajax
          url: "/api/projects/#{@projectId}/members_and_partners.json"
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
            data: { partner: @member }
          .done (response) =>
            toastr.success('', response.message)
            @selectedMemberId = undefined
            @member.man_month = ''
            @member.working_period_start = undefined
            @member.working_period_end = undefined
            @loadMemberPartner()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      editMember: ->
        success_count = 0
        edit = $('.user_member_list__tbl__btn--submit')
        edit.prop('disabled', true)
        if @failureMemberIds.length > 0
          ids = @failureMemberIds
          @failureMemberIds = []
          members = _.filter @members, (p) -> ids.includes(p.id)
        else
          members = @selectedUsers
        $.each members, (i, member) =>
          $.ajax
            url: "/api/user_members/#{@projectId}/#{member.id}.json"
            type: 'PATCH'
            data: { member: member }
          .done (response) =>
            success_count += 1
            toastr.success('', response.message)
            @loadMemberPartner()
            elems = document.getElementById('user-' + member.id).getElementsByTagName('input')
            for i in [0...elems.length]
              elems[i].disabled = true
          .fail (response) =>
            json = response.responseJSON
            @loadMemberPartner()
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
            @failureMemberIds.push(member.id)
          .always =>
            edit.prop('disabled', false)
            if success_count == members.length
              @editMode = false
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
        finally
          destroy.prop('disabled', false)
    created: ->
      @loadMemberPartner()
      @loadPartnersUsers()
