$ ->
  Vue.component 'approvalFileUpload',
    template: '#approval_file_upload'
    props: ['approvalId']
    data: ->
      dragOver: false
      deletedFiles: []
      approvalFiles: []
    ready: ->
      if @approvalId
        $.ajax
          url: "/api/approvals/#{@approvalId}/approval_files.json"
        .done (response) =>
          @approvalFiles = response.approval_files

    methods:
      leave: ->
        @dragOver = false
      over: ->
        if !@dragOver
          @dragOver = true
      onDrop: (event) ->
        @dragOver = false
        @uploadFile(event.dataTransfer.files)
      click: ->
        @$els.fileinput.click()
      onChangeFiles: (event) ->
        @uploadFile(event.currentTarget.files)
      deleteFile: (index) ->
        deletedFile = @approvalFiles.splice(index, 1)
        @deletedFiles.push deletedFile[0]
      approvalFileDownloadUrl: (id)->
        "/api/files/#{id}/approval_file_download"
      uploadFile: (files) ->
        form = new FormData()
        for file in files
          form.append('approval_files[files][]', file)

        $.ajax
          url: '/api/approval_files.json'
          type: 'POST'
          data: form
          cache: false
          contentType: false
          processData: false
        .done (response) =>
          @approvalFiles = @approvalFiles.concat(response.approval_files)
