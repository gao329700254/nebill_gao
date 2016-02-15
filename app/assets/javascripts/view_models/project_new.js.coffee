$ ->
  window.projectNew = new Vue
    el: '#project_new'
    mixins: [Vue.modules.projectHelper]
    data:
      project: undefined
    methods:
      copy: ->
        @project.billing_company_name    = @project.orderer_company_name
        @project.billing_department_name = @project.orderer_department_name
        @project.billing_personnel_names = @project.orderer_personnel_names
        @project.billing_address         = @project.orderer_address
        @project.billing_zip_code        = @project.orderer_zip_code
      submit: ->
        try
          submit = $('.project_new__form__submit_btn')
          submit.prop('disabled', true)
          $.ajax
            url: '/api/projects.json'
            type: 'POST'
            data: {project: @projectPostData}
          .done (response) =>
            toastr.success('', response.message)
            @initializeProject()
          .fail (response) =>
            json = response.responseJSON
            toastr.error(json.errors.full_messages.join('<br>'), json.message, {timeOut: 0})
        finally
          submit.prop('disabled', false)
    created: -> @initializeProject()
