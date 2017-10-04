$ ->
  Vue.component 'memberList',
    template: '#member_list'
    props: ['projectId']
    events:
      addMemberEvent: -> @$dispatch('loadLastUpdatedAtEvent')
      editMemberEvent: -> @$dispatch('loadLastUpdatedAtEvent')
      deleteMemberEvent: -> @$dispatch('loadLastUpdatedAtEvent')
