$ ->
  Vue.component 'clientPersonnelNew',
    template: '#client_personnel_new'
    mixins: [Vue.modules.modal]
    data: ->
      client_personnel:
        name:                 ''
        mail:                 ''
        cc:                   ''
        phone_number:         ''
    methods:
      cancel: -> @modalHide()
      submit: ->
        if @client_personnel.name
          client_personnel = Object.assign({}, @client_personnel)
          @$dispatch('addClientPersonnelEvent', client_personnel)
          @client_personnel.name = ''
          @client_personnel.mail = ''
          @client_personnel.cc = ''
          @client_personnel.phone_number = ''
          @modalHide()
        else
          toastr.error("名前を入力してください", "取引先担当者が作成できませんでした。")
    events:
      showClientPersonnelNewEvent: (e)->
        @modalShow()
