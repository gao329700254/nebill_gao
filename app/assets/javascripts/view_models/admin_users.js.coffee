$ ->
  window.adminUsers = new Vue
    el: '#admin_users'
    methods:
      showUserNew: -> @$broadcast('showUserNewEvent')
    events:
      loadUsersEvent: -> @loadUsers()
