describe 'Cumin', ->
  it 'should setup the objects', ->
    expect(Cumin).to.exist
    expect(Cumin.storageType).to.be.a('string')

  describe '#isConnected', ->
    it 'should return a boolean', ->
      expect(Cumin.isConnected()).to.be.a('boolean')

  context 'when using localStorage', ->
    before ->
      Cumin.storageType = 'localStorage'

    describe '#queue', ->
      it 'should return an array', ->
        expect(Cumin.queue()).to.be.an('object')

    describe '#add', ->
      keys = null

      before ->
        Cumin.add 'http://url',
          foo: 'bar'
        , 'POST'
        keys = Object.keys Cumin.queue()

      it 'should add a request to the queue', ->
        expect(keys).to.have.length(1)
        expect(Cumin.queue()[keys[0]].url).to.equal('http://url')
        expect(Cumin.queue()[keys[0]].data['foo']).to.equal('bar')
        expect(Cumin.queue()[keys[0]].type).to.equal('POST')

    describe '#remove', ->
      before ->
        localStorage.setItem 'cumin.queue', JSON.stringify({foo: 'bar'})
        Cumin.remove 'foo'

      it 'should remove the request from the queue', ->
        expect(Object.keys(Cumin.queue())).to.have.length(0)
