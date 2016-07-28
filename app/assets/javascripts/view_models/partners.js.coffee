$ ->
  window.partners = new Vue
    el: '#partners'
    data: ->
      allPartners: []
      currentCompanyName: undefined
    computed:
      companyNames: ->
        _.uniq(_.pluck(@allPartners, 'company_name'))
      partnerSearchByCompanyName: ->
        _.where(@allPartners, company_name: @currentCompanyName)
    methods:
      setCurrentCompanyName: (companyName) ->
        @currentCompanyName = companyName
    compiled: ->
      $.ajax '/api/partners.json'
        .done (response) =>
          @allPartners = response
