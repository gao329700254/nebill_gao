describe 'select_by', ->
  select_by = Vue.filter('selectBy')

  describe '#filter', ->
    it 'should have a filter function', ->
      expect(typeof select_by).toBe('function')

    describe 'when schema is not an object', ->
      describe 'when eq query', ->
        it 'should filter list by eq', ->
          value = 'CD-1'
          schema = { cd: 'eq' }
          list = [
            { cd: 'CD-1' },
            { cd: 'CD-2' },
            { cd: 'CD-3' },
          ]
          expected_result = [
            { cd: 'CD-1' },
          ]
          expect(select_by(list, value, schema)).toEqual expected_result
      describe 'when like query', ->
        it 'should filter list by like', ->
          value = 'la'
          schema = { name: 'like' }
          list = [
            { name: 'Salair' },
            { name: 'Solarbreeze' },
            { name: 'Cardify' },
          ]
          expected_result = [
            { name: 'Salair' },
            { name: 'Solarbreeze' },
          ]
          expect(select_by(list, value, schema)).toEqual expected_result

    describe 'when schema is an object', ->
      describe 'when eq query', ->
        it 'should filter list by eq', ->
          value = 'CD-2'
          schema = { 'project.cd': 'eq' }
          list = [
            { project: { cd: 'CD-1' } },
            { project: { cd: 'CD-2' } },
            { project: { cd: 'CD-3' } },
          ]
          expected_result = [
            { project: { cd: 'CD-2' } },
          ]
          expect(select_by(list, value, schema)).toEqual expected_result
      describe 'when like query', ->
        it 'should filter list by like', ->
          value = '合名会社'
          schema = { 'bill.project.name': 'like' }
          list = [
            { bill: { project: { name: '合名会社斉藤建設' } } },
            { bill: { project: { name: '合名会社宮本ガス' } } },
            { bill: { project: { name: '酒井電気株式会社' } } },
          ]
          expected_result = [
            { bill: { project: { name: '合名会社斉藤建設' } } },
            { bill: { project: { name: '合名会社宮本ガス' } } },
          ]
          expect(select_by(list, value, schema)).toEqual expected_result
