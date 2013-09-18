describe 'Cumin', ->
  queueLength = null

  before ->
    queueLength = -> Object.keys Cumin.queue()

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

    describe '#clear', ->
      before ->
        localStorage.setItem 'cumin.queue', JSON.stringify({foo: 'bar'})
        Cumin.clear()

      it 'should clear the queue', ->
        expect(Cumin.queue()).to.be.empty

    describe '#add', ->
      keys = null

      before ->
        localStorage.setItem 'cumin.queue', JSON.stringify({})
        Cumin.add 'http://url',
          foo: 'bar'
        , 'POST'
        keys = queueLength()

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
        expect(queueLength()).to.have.length(0)
