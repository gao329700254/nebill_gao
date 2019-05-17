$ ->
  window.approvalGroupsShow = new Vue
    el: '#approval_groups_show'
    data:
      approval_group:
        id:                   undefined
        name:                 undefined
        approval_group_users_attributes: []
        approval_group_users: []
        description:          undefined
        created_at:           undefined
        updated_at:           undefined
      editMode: false
    methods:
      loadApprovalGroup: ->
        $.ajax "/api/approval_groups/#{@approval_group.id}.json"
          .done (response) =>
            @approval_group = response
          .fail (response) =>
            console.error response
      submit: ->
        try
          submit = $('.approval_groups_show__form__btn--submit')
          submit.prop('disabled', true)
          @approval_group.approval_group_users_attributes = @approval_group.approval_group_users

          $.ajax
            url: "/api/approval_groups/#{@approval_group.id}.json"
            type: 'PATCH'
            data:
              approval_group: @approval_group
          .done (response) =>
            toastr.success('', response.message)
            @loadApprovalGroup()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.approval_groups_show__form__btn--delete')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/approval_groups/#{@approval_group.id}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/approval_groups'
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
    compiled: ->
      @loadApprovalGroup()
