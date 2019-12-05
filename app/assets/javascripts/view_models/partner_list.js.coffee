$ ->
  window.partner_list = new Vue
    el: '#partner_list'
    data: ->
      partners: []
    compiled: ->
      $.ajax '/api/partners.json'
        .done (response) =>
          @partners = response
    methods:
      linkToShow: (partnerId) -> window.location = "/partners/#{partnerId}/show"
