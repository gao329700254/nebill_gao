$ ->
  # HACK(hishida): projectDetailと共通化
  window.billShow = new Vue
    el: '#bill_show'
    data:
      billId: undefined
      billSchema:
        id:             { init: '' }
        project_id:     { init: '' }
        cd:             { init: '' }
        amount:         { init: '' }
        delivery_on:    { init: '' }
        acceptance_on:  { init: '' }
        payment_type:   { init: '' }
        bill_on:        { init: '' }
        deposit_on:     { init: '' }
        created_at:     { init: '' }
        updated_at:     { init: '' }
      editMode: false
      partnerEditMode: false
      bill: undefined
      billOriginal: undefined
      partners: []
      allPartners: []
      partnerOriginal: undefined
      selectedPartnerId: undefined
      failurePartnerIds: []
      member:
        unit_price: ''
        working_rate: ''
        min_limit_time: ''
        max_limit_time: ''
      users: []
      allUsers: []
      project: []
      selectedUserId: undefined
    computed:
      billInit: -> _.mapObject @billSchema, (value, key) -> value.init
      selectablePartners: ->
        ids = _.pluck(@partners, 'id')
        _.reject @allPartners, (p) ->
          _.includes(ids, p.id)
      selectedPartners: -> _.filter @partners, (p) -> p.selected
      selectableUsers: ->
        ids = _.pluck(@users, 'id')
        _.reject @allUsers, (p) ->
          _.includes(ids, p.id)
      selectedUsers: -> _.filter @users, (u) -> u.selected
    watch:
      billId: ->
        @loadBill()
        @loadProject()
      editMode: (val) ->
        @bill = $.extend(true, {}, @billOriginal) unless val
      partnerEditMode: (val) ->
        @partners = $.extend(true, {}, @partnerOriginal) unless val
    methods:
      initializeBill: -> @bill = $.extend(true, {}, @billInit)
      loadBill: ->
        $.ajax "/api/bills/#{@billId}.json"
          .done (response) =>
            @billOriginal = response
            @bill = $.extend(true, {}, @billOriginal)
          .fail (response) =>
            console.error response
      loadPartners: ->
        $.ajax "/api/bills/#{@billId}/partners"
          .done (response) =>
            @partnerOriginal = response
            @partners = $.extend(true, {}, @partnerOriginal)
      loadAllPartners: ->
        $.ajax '/api/partners'
          .done (response) =>
            @allPartners = response
      loadUsers: ->
        $.ajax "/api/bills/#{@billId}/users"
          .done (response) =>
            @users = response
      loadAllUsers: ->
        $.ajax '/api/users'
          .done (response) =>
            @allUsers = response
      loadProject: ->
        $.ajax "/api/projects/bill/#{@billId}.json"
          .done (response) =>
            @project = response
      editModeOn: ->
        @partnerEditMode = true
        _.each @selectedPartners, (v, k) ->
          elems = document.getElementById('partner-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = false
      editModeOff: ->
        @partnerEditMode = false
        @failurePartnerIds = []
        _.each @partners, (v, k) ->
          elems = document.getElementById('partner-' + v.id).getElementsByTagName('input')
          for i in [0...elems.length]
            elems[i].disabled = true
      submit: ->
        try
          submit = $('.bill_show__form__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/bills/#{@billId}.json"
            type: 'PATCH'
            data:
              bill:
                cd:             @bill.cd
                amount:         @bill.amount
                delivery_on:    @bill.delivery_on
                acceptance_on:  @bill.acceptance_on
                payment_type:   @bill.payment_type
                bill_on:        @bill.bill_on
                deposit_on:     @bill.deposit_on
                memo:           @bill.memo
          .done (response) =>
            toastr.success('', response.message)
            @loadBill()
            @editMode = false
          .fail (response) =>
            json = response.responseJSON
            if _.has(json, 'errors')
              toastr.error(json.errors.full_messages.join('<br>'), json.message)
            else
              toastr.error('', json.message)
        finally
          submit.prop('disabled', false)
      destroy: ->
        try
          destroy = $('.bill_show__form__btn--delete')
          destroy.prop('disabled', true)
          if(confirm($('#header__delete_confirm_message').val()))
            $.ajax
              url: "/api/bills/#{@billId}.json"
              type: 'DELETE'
            .done (response) =>
              window.location = '/bills/list'
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      addMember: ->
        return unless @selectedPartnerId?
        try
          addMember = $('.bill_show__form__member_list__add_partner_member__btn')
          addMember.prop('disabled', true)
          $.ajax
            url: "/api/partner_members/#{@billId}/#{@selectedPartnerId}.json"
            type: 'POST'
            data: { member: @member }
          .done (response) =>
            toastr.success('', response.message)
            @selectedPartnerId = undefined
            @member.unit_price = ''
            @member.working_rate = ''
            @member.min_limit_time = ''
            @member.max_limit_time = ''
            @loadBill()
            @loadPartners()
            @loadAllPartners()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          addMember.prop('disabled', false)
      editMember: ->
        success_count = 0
        edit = $('.bill_show__form__member_list__partner_btn--submit')
        edit.prop('disabled', true)
        if @failurePartnerIds.length > 0
          ids = @failurePartnerIds
          @failurePartnerIds = []
          partners = _.filter @partners, (p) -> ids.includes(p.id)
        else
          partners = @selectedPartners
        $.each partners, (i, partner) =>
          $.ajax
            url: "/api/partner_members/#{@billId}/#{partner.id}.json"
            type: 'PATCH'
            data:
              members:
                unit_price:       partner.member.unit_price
                working_rate:     partner.member.working_rate
                min_limit_time:   partner.member.min_limit_time
                max_limit_time:   partner.member.max_limit_time
                partner_attributes: {
                  id:               partner.id
                  name:             partner.name
                }
          .done (response) =>
            success_count += 1
            toastr.success('', response.message)
            @loadPartners()
            elems = document.getElementById('partner-' + partner.id).getElementsByTagName('input')
            for i in [0...elems.length]
              elems[i].disabled = true
            @loadBill()
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
              @partnerEditMode = false
      deleteMember: ->
        try
          destroy = $('.bill_show__form__member_list__partner_btn--delete')
          destroy.prop('disabled', true)
          $.each @selectedPartners, (i, partner) =>
            $.ajax
              url: "/api/partner_members/#{@billId}/#{partner.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadPartners()
              @loadAllPartners()
              @loadBill()
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      addUserMember: ->
        return unless @selectedUserId?
        try
          submit = $('.bill_show__form__member_list__add_user_member__btn--submit')
          submit.prop('disabled', true)
          $.ajax
            url: "/api/user_members/#{@billId}/#{@selectedUserId}.json"
            type: 'POST'
          .done (response) =>
            toastr.success('', response.message)
            @selectedUserId = undefined
            @loadUsers()
            @loadAllUsers()
            @loadBill()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      deleteUserMember: ->
        try
          destroy = $('.bill_show__form__member_list__add_user_member__user_btn--delete')
          destroy.prop('disabled', true)
          $.each @selectedUsers, (i, user) =>
            $.ajax
              url: "/api/user_members/#{@billId}/#{user.id}.json"
              type: 'DELETE'
            .done (response) =>
              toastr.success('', response.message)
              @loadUsers()
              @loadAllUsers()
              @loadBill()
            .fail (response) =>
              json = response.responseJSON
              if _.has(json, 'errors')
                toastr.error(json.errors.full_messages.join('<br>'), json.message)
              else
                toastr.error('', json.message)
        finally
          destroy.prop('disabled', false)
      showPartnerNew: -> @$broadcast('showPartnerNewEvent')
    created: -> @initializeBill()
    compiled: ->
      @loadPartners()
      @loadAllPartners()
      @loadUsers()
      @loadAllUsers()
    events:
      loadAllPartnersEvent: (partnerId) ->
        @loadAllPartners()
        @selectedPartnerId = partnerId
      loadProjectEvent: ->
        @loadProject()
