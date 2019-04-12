$ ->
  window.approvalShow = new Vue
    el: '#approval_new'
    ready: () ->
      # nested_fields_forの中ではvueJSのeventbindingが使えないため、ここで無理やりイベントを発行するようにしています。
      $(@$el).on('dragleave', '.approval_new__form__item__file__drop_container',(e)=>
        e.preventDefault()
        @leave(e)
      )
      $(@$el).on('dragover', '.approval_new__form__item__file__drop_container',(e)=>
        e.preventDefault()
        @over(e)
      )
      $(@$el).on('drop', '.approval_new__form__item__file__drop_container',(e)=>
        e.preventDefault()
        @onDrop(e)
      )
    methods:
      leave: (e) ->
        e.currentTarget.classList.remove('over')
      over: (e) ->
        e.currentTarget.classList.add('over')
      onDrop: (e) ->
        e.currentTarget.classList.remove('over')
        $(e.currentTarget).siblings('input[type=file]')[0].files = e.originalEvent.dataTransfer.files
