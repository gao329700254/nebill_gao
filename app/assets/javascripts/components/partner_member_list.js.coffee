$ ->
  Vue.component 'partnerMemberList',
    template: '#partner_member_list'
    props: ['projectId']
    data: ->
      partners: []
      selectedPartnerId: undefined
      member:
        unit_price: ''
        working_rate: ''
        min_limit_time: ''
        max_limit_time: ''
        working_period_start: undefined
        working_period_end: undefined
      editMode: false
      failurePartnerIds: []
      allPartners: []
    computed:
      selectedPartners: -> _.filter @partners, (p) -> p.selected
      selectablePartners: ->
        ids = _.pluck(@partners, 'employee_id')
        _.reject @allPartners, (p) ->
          _.includes(ids, p.id)
    methods:
      editModeOn: ->
        @editMode = true
        _.each @selectedPartners, (v, k) ->
          elems = document.getElementById('partner-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = false
      editModeOff: ->
        @editMode = false
        @failurePartnerIds = []
        _.each @partners, (v, k) ->
          elems = document.getElementById('partner-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = true
      loadPartners: ->
        $.ajax
          url: "/api/projects/#{@projectId}/member_partner.json"
          type: 'POST'
          data: { type: 'PartnerMember' }
        .done (response) =>
          @partners = response
      loadPartnersUsers: ->
        @allPartners = []
        $.ajax '/api/projects/load_partner_user.json'
          .done (response) =>
            response.forEach (emp) =>
              if emp.actable_type == 'Partner'
                @allPartners.push(emp)
      editMember: ->
        success_count = 0
        edit = $('.partner_member_list__btn--submit')
        edit.prop('disabled', true)
        if @failurePartnerIds.length > 0
          ids = @failurePartnerIds
          @failurePartnerIds = []
          partners = _.filter @partners, (p) -> ids.includes(p.id)
        else
          partners = @selectedPartners
        $.each partners, (i, partner) =>
          $.ajax
            url: "/api/partner_members/#{@projectId}/#{partner.id}.json"
            type: 'PATCH'
            data: { member: partner }
          .done (response) =>
            success_count += 1
            toastr.success('', response.message)
            @loadPartners()
            elems = document.getElementById('partner-' + partner.id).getElementsByTagName('input')
            for i in [0...elems.length]
              elems[i].disabled = true
          .fail (response) =>
            json = response.responseJSON
            @loadPartners()
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
            @failurePartnerIds.push(partner.id)
          .always =>
            edit.prop('disabled', false)
            if success_count == partners.length
              @editMode = false
      createPartner: ->
        return unless @selectedPartnerId?
        try
          submit = $('.partner_member_list__partner_btn')
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
            @member.working_period_start = undefined
            @member.working_period_end = undefined
            @loadPartners()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      deletePartnerMember: ->
        try
          destroy = $('.partner_member_list__btn--delete')
          destroy.prop('disabled', true)
          $.each @selectedPartners, (i, user) =>
            $.ajax
              url: "/api/partner_members/#{@projectId}/#{user.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadPartners()
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      showPartnerNew: -> @$broadcast('showPartnerNewEvent')
    created: ->
      @loadPartners()
      @loadPartnersUsers()
    events:
      loadPartnersEvent: (partnerId) ->
        @loadPartnersUsers()
