Vue.modules.projectHelper = {
  data: ->
    projectSchema:
      id:
        init: ''
        exist: { contracted: false, uncontracted: false }
      group_id:
        init: ''
        exist: { contracted: true, uncontracted: true }
      contracted:
        init: false
        exist: { contracted: true, uncontracted: true }
      key:
        init: ''
        exist: { contracted: true, uncontracted: true }
      name:
        init: ''
        exist: { contracted: true, uncontracted: true }
      contract_on:
        init: ''
        exist: { contracted: true, uncontracted: true }
      contract_type:
        init: 'lump_sum'
        exist: { contracted: true, uncontracted: false }
      is_using_ses:
        init: false
        exist: { contracted: true, uncontracted: false }
      contractual_coverage:
        init: 'development'
        exist: { contracted: true, uncontracted: false }
      start_on:
        init: ''
        exist: { contracted: true, uncontracted: false }
      end_on:
        init: ''
        exist: { contracted: true, uncontracted: false }
      amount:
        init: 0
        exist: { contracted: true, uncontracted: false }
      payment_type:
        init: 'end_of_the_delivery_date_next_month'
        exist: { contracted: true, uncontracted: false }
      orderer_company_name:
        init: ''
        exist: { contracted: true, uncontracted: true }
      orderer_department_name:
        init: ''
        exist: { contracted: true, uncontracted: true }
      orderer_personnel_names:
        init: []
        exist: { contracted: true, uncontracted: true }
      orderer_address:
        init: ''
        exist: { contracted: true, uncontracted: true }
      orderer_zip_code:
        init: ''
        exist: { contracted: true, uncontracted: true }
      orderer_memo:
        init: ''
        exist: { contracted: true, uncontracted: true }
      billing_company_name:
        init: ''
        exist: { contracted: true, uncontracted: true }
      billing_department_name:
        init: ''
        exist: { contracted: true, uncontracted: true }
      billing_personnel_names:
        init: []
        exist: { contracted: true, uncontracted: true }
      billing_address:
        init: ''
        exist: { contracted: true, uncontracted: true }
      billing_zip_code:
        init: ''
        exist: { contracted: true, uncontracted: true }
      billing_memo:
        init: ''
        exist: { contracted: true, uncontracted: true }
      created_at:
        init: ''
        exist: { contracted: false, uncontracted: false }
      updated_at:
        init: ''
        exist: { contracted: false, uncontracted: false }
    project: undefined
  computed:
    projectInit: -> _.mapObject @projectSchema, (value, key) -> value.init
    projectPostData: ->
      if @project.contracted
        _.pick @project, (value, key) => @projectSchema[key].exist.contracted
      else
        _.pick @project, (value, key) => @projectSchema[key].exist.uncontracted
    project_orderer_personnel_names_str:
      get: -> @project.orderer_personnel_names.join(', ')
      set: (val) -> @project.orderer_personnel_names = val.split(/[\s　]*[,、][\s　]*/)
    project_billing_personnel_names_str:
      get: -> @project.billing_personnel_names.join(', ')
      set: (val) -> @project.billing_personnel_names = val.split(/[\s　]*[,、][\s　]*/)
  methods:
    initializeProject: -> @project = $.extend(true, {}, @projectInit)
}
