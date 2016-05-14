Vue.filter 'selectBy', (list, value, schema) ->
  return list unless value?

  _.filter list, (item) ->
    _.all value.trim().split(/[\s　]+/), (query) ->
      _.any schema, (cods, col) ->
        val = item
        for t in col.split('.')
          val = val[t]
        switch cods
          when 'eq'
            return val == query
          when 'like'
            if val?
              return val.match(query)
            else
              return false
