$ ->
  window.approvalShow = new Vue
    el: '#approval_show'
    data:
      url: undefined
    methods:
      showApprovalFile: (element) ->
        @url = element
        if element.includes('.pdf')
          window.open(element)
        else
          @$broadcast('showApprovalFileEvent')
