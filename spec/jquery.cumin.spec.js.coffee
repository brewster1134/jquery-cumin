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

  describe '#set', ->
    before ->
      Cumin.set 'foo', 'bar'

    it 'should set settings', ->
      expect(Cumin.settings.foo).to.exist
      expect(Cumin.settings.foo).to.equal('bar')

  describe '#setEvent', ->
    before ->
      Cumin.setEvent 'onFoo', 'bar'

    it 'should set settings', ->
      expect(Cumin.events.onFoo).to.exist
      expect(Cumin.events.onFoo).to.equal('bar')

  context 'when using events', ->
    describe 'onQueueChange', ->
      before ->
        Cumin.events.onQueueChange = sinon.spy()
        Cumin.add 'http://url'

      it 'should be called when queue changes', ->
        expect(Cumin.events.onQueueChange).to.be.called

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
