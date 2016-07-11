$ ->
  window.adminUsers = new Vue
    el: '#admin_users'
    events:
      createUserEvent: -> @$broadcast('loadUsersEvent')
