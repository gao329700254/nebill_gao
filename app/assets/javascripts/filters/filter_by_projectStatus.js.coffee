Vue.filter 'filterByprojectStatus', (list, value) ->

  _.filter list, (item) ->
    switch value
      when 'finished'
        console.log(item)
        return item.status == '終了'
      when 'progress'
        # プロジェクトが、「終了」しておらず「失注」もしていないものを取得する
        return item.status != '終了' && item.unprocessed == false
      when 'unprocessed'
        return item.unprocessed == true
      when 'all_pjt_status'
        return list
