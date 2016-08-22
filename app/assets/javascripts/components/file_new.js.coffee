$ ->
  Vue.component 'fileNew',
    template: '#file_new'
    props: ['projectId']
    data: ->
      file_input: undefined
      files: undefined
    methods:
      fileInputChange: (e) ->
        @file_input = e.target
        @files = @file_input.files
      fileUpload: ->
        return if @files.length <= 0
        try
          submit = $('.file_new__form__submit_btn')
          submit.prop('disabled', true)
          $.each Array.prototype.slice.call(@files, 0), (i, file) =>
            @_handleUpload(file)
          @file_input.value = ''
          @$dispatch('uploadFileEvent')
        finally
          submit.prop('disabled', false)
      _handleUpload: (file) ->
        form = new FormData()
        form.append('Content-Type', file.type || 'application/octet-stream')
        form.append('file', file)

        $.ajax
          url: "/api/projects/#{@projectId}/project_files.json"
          type: 'POST'
          data: form
          cache: false
          contentType: false
          processData: false
        .done (response) =>
          toastr.success('', response.message)
        .fail (response) =>
          json = response.responseJSON
          toastr.error(json.errors.full_messages.join('<br>'), json.message, { timeOut: 0 })
