$ ->
  window.adminUsers = new Vue
    el: '#admin_users'
    data:
      user:
        email: ''
        is_admin: false
    methods:
      createUser: ->
        try
          submit = $('.admin_users__new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/users.json'
            type: 'POST'
            data:
              user:
                email:    @user.email
                is_admin: @user.is_admin
          .done (response) =>
            toastr.success('', response.message)
            @user.email = ''
            @user.is_admin = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
