$ ->
  Vue.component 'projectNew',
    template: '#project_new'
    mixins: [Vue.modules.projectHelper, Vue.modules.modal]
    data: ->
      clients: []
      project: undefined
      ordererClientId: undefined
      billingClientId: undefined
      client:
        company_name:     undefined
        department_name:  undefined
        address:          undefined
        zip_code:         undefined
        phone_number:     undefined
        memo:             undefined
      allUsers: []
      partners: []
      members: []
      allPartners: []
      allMembers: []
    methods:
      cancel: -> @modalHide()
      setProjectCd: ->
        projectContracted = @project.contracted
        projectType = @project.contract_type
        $.ajax
          url: "/api/projects/cd/#{projectType}.json"
          data:
            project_contracted: projectContracted
        .done (response) =>
          @project.cd = response.cd
      loadClients: ->
        $.ajax '/api/clients/published_clients.json'
          .done (response) =>
            @clients = []
            response.forEach (element) =>
              @clients.push(element)
      fillOrderer: ->
        $.ajax "/api/clients/#{@ordererClientId}.json"
          .done (response) =>
            @project.orderer_company_name     = response.company_name
            @project.orderer_department_name  = response.department_name
            @project.orderer_address          = response.address
            @project.orderer_zip_code         = response.zip_code
            @project.orderer_phone_number     = response.phone_number
      fillBilling: ->
        $.ajax "/api/clients/#{@billingClientId}.json"
          .done (response) =>
            @project.billing_company_name     = response.company_name
            @project.billing_department_name  = response.department_name
            @project.billing_address          = response.address
            @project.billing_zip_code         = response.zip_code
            @project.billing_phone_number     = response.phone_number
      copy: ->
        @project.billing_company_name    = @project.orderer_company_name
        @project.billing_department_name = @project.orderer_department_name
        @project.billing_personnel_names = @project.orderer_personnel_names
        @project.billing_address         = @project.orderer_address
        @project.billing_zip_code        = @project.orderer_zip_code
        @project.billing_phone_number    = @project.orderer_phone_number
      submit: ->
        try
          submit = $('.project_new__form__submit_btn')
          submit.prop('disabled', true)
          if @partners.length > 0 || @members.length > 0
            @projectPostData.members_attributes = []
          if @partners.length > 0
            @partners.forEach (partner) =>
              if partner.employee_id
                partner.type = 'PartnerMember'
                @projectPostData.members_attributes.push(partner)
          if @members.length > 0
            @members.forEach (member) =>
              if member.employee_id
                member.type = 'UserMember'
                @projectPostData.members_attributes.push(member)
          $.ajax
            url: '/api/projects.json'
            type: 'POST'
            data: { project: @projectPostData }
          .done (response) =>
            toastr.success('', response.message)
            @initializeProject()
            @modalHide()
            @$dispatch('loadSearchEvent')
            @partners = []
            @members = []
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message)
        finally
          submit.prop('disabled', false)
      loadAllUsers: ->
        $.ajax '/api/users'
          .done (response) =>
            @allUsers = response
      loadPartnersUsers: ->
        $.ajax '/api/projects/load_partner_user.json'
          .done (response) =>
            response.forEach (emp) =>
              if emp.actable_type == 'Partner'
                @allPartners.push(emp)
              else if emp.actable_type == 'User'
                @allMembers.push(emp)
      addPartnerMemberForm: ->
        @partners.push({
          employee_id: '',
          unit_price: '',
          working_rate: '',
          min_limit_time: '',
          max_limit_time: '' })
      addUserMemberForm: ->
        @members.push({ employee_id: '' })
      deletePartnerMemberForm: (index) ->
        @partners.splice(index, 1)
      deleteUserMemberForm: (index) ->
        @members.splice(index, 1)
    created: ->
      @loadClients()
      @initializeProject()
      @setProjectCd()
      @loadAllUsers()
      @loadPartnersUsers()
    events:
      showProjectNewEvent: -> @modalShow()
