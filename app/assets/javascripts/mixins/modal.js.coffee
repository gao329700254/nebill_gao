Vue.modules.modal = {
  data: ->
    modalActive: false
    modalStyle:
      active:
        opacity: 1
        visibility: 'visible'
      nonActive:
        opacity: 0
        visibility: 'hidden'
  methods:
    modalShow: -> @modalActive = true
    modalHide: -> @modalActive = false
    modalToggle: -> @modalActive = !@modalActive
}
