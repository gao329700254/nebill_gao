$ ->
  Vue.component 'partnerMemberList',
    template: '#partner_member_list'
    props: ['projectId']
    data: ->
      partners: []
      allPartners: []
      selectedPartnerId: undefined
    computed:
      selectablePartners: ->
        ids = _.pluck(@partners, 'id')
        _.reject @allPartners, (p) ->
          _.includes(ids, p.id)
    methods:
      loadPartners: ->
        $.ajax "/api/projects/#{@projectId}/partners"
          .done (response) =>
            @partners = response
      loadAllPartners: ->
        $.ajax '/api/partners'
          .done (response) =>
            @allPartners = response
      addMember: ->
        return unless @selectedPartnerId?
        try
          submit = $('.partner_member_list__new_member__btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/partner_members/#{@projectId}/#{@selectedPartnerId}.json"
            type: 'POST'
          .done (response) =>
            toastr.success('', response.message)
            @selectedPartnerId = undefined
            @loadPartners()
            @loadAllPartners()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
      showPartnerNew: -> @$broadcast('showPartnerNewEvent')
    events:
      loadAllPartnersEvent: (partnerId) ->
        @loadAllPartners()
        @selectedPartnerId = partnerId
    compiled: ->
      @loadPartners()
      @loadAllPartners()