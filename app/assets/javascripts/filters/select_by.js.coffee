Vue.filter 'selectBy', (list, value, schema) ->
  return list unless value?

  _.filter list, (item) ->
    _.all value.trim().split(/[\s　]+/), (query) ->
      _.any schema, (cods, col) ->
        switch cods
          when 'eq'
            return item[col] == query
          when 'like'
            if item[col]?
              return item[col].match(query)
            else
              return false
