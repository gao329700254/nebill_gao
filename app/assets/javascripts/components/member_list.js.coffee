$ ->
  Vue.component 'memberList',
    template: '#member_list'
    methods:
      showPartnerNew: -> @$broadcast('showPartnerNewEvent')
