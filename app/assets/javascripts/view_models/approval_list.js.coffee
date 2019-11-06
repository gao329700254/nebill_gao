$ ->
  window.approvalList = new Vue
    el: '#approval_list'
    data:
      selectSchema:
        name: 'like'
        created_user_name: 'like'
      search_keywords: ''
      status: ''
      created_at: ''
      category: ''
    methods:
      # coffeelint: disable=no_empty_param_list
      search: () ->
        window.location = "/approvals/list?status=#{@status}&category=#{@category}&created_at=#{@created_at}&search_keywords=#{@search_keywords}"
