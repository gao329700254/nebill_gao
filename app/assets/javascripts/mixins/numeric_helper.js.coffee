Vue.modules.numericHelper = {
  methods:
    setComma: (elem) ->
      number = elem.target.value
      number = number.replace(',、', '') # カンマ削除
      number = number.replace(/[０-９]/g, (elem) ->
        String.fromCharCode(elem.charCodeAt(0) - 65248)) # 全角数字から半角数字に変換
      elem.target.value = number.replace(/\D/g, '')
        .replace(/^0+/, '')
        .replace(/\B(?=(\d{3})+(?!\d))/g, ',')
      elem.preventDefault()
}
