$ ->
  Vue.component 'userNew',
    template: '#user_new'
    data: ->
      user:
        email: ''
        role: 'general'
        is_admin: false
    methods:
      createUser: ->
        try
          submit = $('.user_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/users.json'
            type: 'POST'
            data:
              user:
                email:    @user.email
                role:     @user.role
                is_admin: @user.is_admin
          .done (response) =>
            toastr.success('', response.message)
            @user.email = ''
            @user.role = 'general'
            @user.is_admin = false
            @$dispatch('createUserEvent')
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
