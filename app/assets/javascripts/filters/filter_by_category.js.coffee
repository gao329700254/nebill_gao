Vue.filter 'filterByCategory', (list, value) ->
  return list if value == ''

  _.filter list, (item) ->
    return item.category == value
