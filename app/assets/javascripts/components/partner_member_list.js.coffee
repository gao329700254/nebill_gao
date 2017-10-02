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
      editMode: false
      partnerOriginal: undefined
      failurePartnerIds: []
    computed:
      selectablePartners: ->
        ids = _.pluck(@partners, 'id')
        _.reject @allPartners, (p) ->
          _.includes(ids, p.id)
      selectedPartners: -> _.filter @partners, (p) -> p.selected
    watch:
      editMode: (val) ->
        @partners = $.extend(true, {}, @partnerOriginal) unless val
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
        $.ajax "/api/projects/#{@projectId}/partners"
          .done (response) =>
            @partnerOriginal = response
            @partners = $.extend(true, {}, @partnerOriginal)
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
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
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
            data:
              members:
                unit_price:       partner.member.unit_price
                working_rate:     partner.member.working_rate
                min_limit_time:   partner.member.min_limit_time
                max_limit_time:   partner.member.max_limit_time
                partner_attributes: {
                  id:               partner.id
                  cd:               partner.cd
                  name:             partner.name
                  email:            partner.email
                  company_name:     partner.company_name
                }
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
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
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
