$ ->
  window.approvalGroupsShow = new Vue
    el: '#approval_groups_show'
    data:
      approval_group:
        name:                 ''
        approval_group_users_attributes: []
        approval_group_users: []
        description:          ''
        created_at:           ''
        updated_at:           ''
    methods:
      submit: ->
        try
          submit = $('.approval_groups_show__form__btn--submit')
          submit.prop('disabled', true)
          @approval_group.approval_group_users_attributes = @approval_group.approval_group_users

          $.ajax
            url: '/api/approval_groups.json'
            type: 'POST'
            data:
              approval_group: @approval_group
          .done (response) =>
            window.location = '/approval_groups'
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
