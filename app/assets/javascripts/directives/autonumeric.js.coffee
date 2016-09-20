Vue.directive 'numeric',
  twoWay: true
  bind: ->
    $(@el)
      .autoNumeric('init', aPad: false)
      .on 'change', =>
        @set $(@el).autoNumeric('get')
  update: (value) ->
    el = $(@el).autoNumeric('set', value)
    el.trigger('change') if el?
  unbind: ->
    $(@el).autoNumeric('destroy')
