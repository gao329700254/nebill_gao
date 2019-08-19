Vue.filter 'filterBycontractStatus', (list, value) ->

  _.filter list, (item) ->
    switch value
      when 'contracted'
        return item.contracted == true
      when 'uncontracted'
        return item.contracted == false
      when 'all_contract_type'
        return list
