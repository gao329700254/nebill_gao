$ ->
  window.userShow = new Vue
    el: '#user_show'
    data:
      userId: undefined
      userSchema:
        id:               { init: '' }
        name:             { init: '' }
        email:            { init: '' }
        role:             { init: '' }
        default_allower:  { init: '' }
        chatwork_id:      { init: '' }
        created_at:       { init: '' }
        updated_at:       { init: '' }
      editMode: false
      user: undefined
      userOrigin: undefined
      allUsers: []
      allUser: []
    computed:
      userInit: -> _.mapObject @userSchema, (value, key) -> value.init
    watch:
      userId: ->
        @loadUser()
        @loadAllUsers()
      editMode: (val) ->
        @user = $.extend(true, {}, @userOriginal) unless val
    methods:
      initializeUser: -> @user = $.extend(true, {}, @userInit)
      loadUser: ->
        $.ajax "/api/users/#{@userId}.json"
          .done (response) =>
            @userOriginal = response
            @user = $.extend(true, {}, @userOriginal)
          .fail (response) =>
            console.error response
      loadAllUsers: ->
        $.ajax '/api/users'
          .done (response) =>
            @allUsers = response
            @allUsers
            response.forEach (element) =>
              if element.id != parseInt(@userId)
                @allUser.push(element)
      send_password_setting_email: ->
        $.ajax
          url: "/api/users/#{@userId}/send_password_setting_emails.json"
          type: 'POST'
        .done (response) =>
          toastr.success('', response.message)
          @loadUser()
          @editMode = false
        .fail (response) =>
          json = response.responseJSON
          toastr.error(json.errors.full_messages.join('<br>'), json.message)
        .always (response) =>
          submit.prop('disabled', false)
      submit: ->
        try
          submit = $('.user_show__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/users/#{@userId}.json"
            type: 'PATCH'
            data:
              user:
                name:            @user.name
                email:           @user.email
                role:            @user.role
                default_allower: @user.default_allower
                chatwork_id:     @user.chatwork_id
          .done (response) =>
            toastr.success('', response.message)
            @loadUser()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.user_detail__form__btn--delete')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/users/#{@userId}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/admin/users'
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
    created: -> @initializeUser()
