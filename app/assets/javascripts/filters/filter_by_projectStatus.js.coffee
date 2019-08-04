Vue.filter 'filterByprojectStatus', (list, value) ->

  _.filter list, (item) ->
    switch value
      when 'finished'
        return item.finished?
      when 'progress'
        # プロジェクトのstatusが、finished以外のものを取得する
        return !item.finished?
      when 'unprocessed'
        return item.unprocessed == true
      when 'all_pjt_status'
        return list
