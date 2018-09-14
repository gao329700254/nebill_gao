Vue.filter 'statusBy', (list, value) ->

  _.filter list, (item) ->
    val = item['status']
    # return true
    if value
      if val == '終了'
        return true
      else
        return false
    else
      return true
