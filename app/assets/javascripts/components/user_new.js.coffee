$ ->
  Vue.component 'userNew',
    template: '#user_new'
    mixins: [Vue.modules.modal]
    data: ->
      user:
        name:            ''
        email:           ''
        role:            ''
        default_allower: ''
        chatwork_id:     ''
      allUsers: []
    methods:
      loadAllUsers: ->
        $.ajax '/api/users.json'
          .done (response) =>
            @allUsers
            response.forEach (element) =>
              @allUsers.push(element)
      cancel: -> @modalHide()
      submit: ->
        try
          submit = $('.user_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/users.json'
            type: 'POST'
            data: { user: @user }
          .done (response) =>
            toastr.success('', response.message)
            @user = _.mapObject @user, (v, k) -> undefined
            @modalHide()
            @$dispatch('loadUserEvent')
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
    created: ->
      @loadAllUsers()
    events:
      showUserNewEvent: -> @modalShow()
