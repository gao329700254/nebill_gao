$ ->
  Vue.component 'partnerMemberList',
    template: '#partner_member_list'
    props: ['projectId']
    data: ->
      partners: []
      allPartners: []
      selectedPartnerId: undefined
      member:
        unit_price: ''
        working_rate: ''
        min_limit_time: ''
        max_limit_time: ''
    computed:
      selectablePartners: ->
        ids = _.pluck(@partners, 'id')
        _.reject @allPartners, (p) ->
          _.includes(ids, p.id)
      selectedPartners: -> _.filter @partners, (p) -> p.selected
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
          submit = $('.partner_member_list__add_member__btn')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/partner_members/#{@projectId}/#{@selectedPartnerId}.json"
            type: 'POST'
            data: { member: @member }
          .done (response) =>
            toastr.success('', response.message)
            @selectedPartnerId = undefined
            @member.unit_price = ''
            @member.working_rate = ''
            @member.min_limit_time = ''
            @member.max_limit_time = ''
            @loadPartners()
            @loadAllPartners()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
        finally
          submit.prop('disabled', false)
      deleteMember: ->
        try
          destroy = $('.partner_member_list__btn--delete')
          destroy.prop('disabled', true)
          $.each @selectedPartners, (i, partner) =>
            $.ajax
              url: "/api/partner_members/#{@projectId}/#{partner.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadPartners()
              @loadAllPartners()
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      showPartnerNew: -> @$broadcast('showPartnerNewEvent')
    events:
      loadAllPartnersEvent: (partnerId) ->
        @loadAllPartners()
        @selectedPartnerId = partnerId
    compiled: ->
      @loadPartners()
      @loadAllPartners()
