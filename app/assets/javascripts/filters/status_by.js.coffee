Vue.filter 'statusBy', (list, value) ->

  _.filter list, (item) ->
    val = item['status']
    if value
      if val == '失注' or val == '終了'
        return true
      else
        return false
    else
      return true
