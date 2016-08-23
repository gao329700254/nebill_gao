class Dropdown
  @hide_all: ->
    $('[data-dropdown__content]').hide()
  @show: (item) ->
    @hide_all()
    $(item).closest('[data-dropdown]').find('[data-dropdown__content]').show()

$ ->
  Dropdown.hide_all()

  $(document).on 'click', (e) ->
    Dropdown.hide_all()
  $(document).on 'click', '[data-dropdown__btn]', (e) ->
    e.stopPropagation()
    Dropdown.show(@)
  $(document).on 'click', '[data-dropdown__content]', (e) ->
    e.stopPropagation()
