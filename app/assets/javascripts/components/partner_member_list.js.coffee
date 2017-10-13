$ ->
  Vue.component 'partnerMemberList',
    template: '#partner_member_list'
    props: ['projectId']
    data: ->
      partners: []
      selectedPartnerId: undefined
      project:
        status: undefined
      partner:
        id: ''
        name: ''
        email: ''
        company_name: ''
      editMode: false
      partnerOriginal: undefined
      failurePartnerIds: []
    computed:
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
      loadProject: ->
        $.ajax "/api/projects/#{@projectId}.json"
          .done (response) =>
            @project = response
      loadPartners: ->
        $.ajax "/api/projects/#{@projectId}/partners"
          .done (response) =>
            @partnerOriginal = response
            @partners = $.extend(true, {}, @partnerOriginal)
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
            url: "/api/partners/#{partner.id}.json"
            type: 'PATCH'
            data:
              partner:
                cd:           partner.cd
                name:         partner.name
                email:        partner.email
                company_name: partner.company_name
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
    events:
      loadProjectEvent: ->
        @loadProject()
    compiled: ->
      @loadPartners()
      @loadProject()
