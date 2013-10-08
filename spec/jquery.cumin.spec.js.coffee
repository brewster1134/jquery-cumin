describe 'Cumin', ->
  queueLength = null

  before ->
    queueLength = -> Object.keys Cumin.queue()

  it 'should setup the objects', ->
    expect(Cumin).to.exist
    expect(Cumin.storageType).to.be.a('string')

  context 'Public Methods', ->
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

    describe '#send', ->
      requestStub = null

      before ->
        requestStub = sinon.stub Cumin, 'request'

        Cumin.send 'url',
          foo: 'bar'
        , 'POST'

      after ->
        requestStub.restore()

      it 'should send a request', ->
        expect(requestStub).to.be.called.once

  describe '#isConnected', ->
    it 'should return a boolean', ->
      expect(Cumin.isConnected()).to.be.a('boolean')

  describe '#request', ->
    before ->
      Cumin.add 'request'
      Cumin.request 'request',
        url: 'http://'
        data: {}
        type: 'GET'
        sendCount: 1

    it 'should increase the sendCount by 1', ->
      expect(Cumin.queue()['request'].sendCount).to.equal(2)

  context 'when using events', ->
    describe 'onQueueChange', ->
      before ->
        Cumin.setEvent 'onQueueChange', sinon.spy()
        Cumin.add
          url: 'http://url'

      it 'should be called when queue changes', ->
        expect(Cumin.events.onQueueChange).to.be.called

  for storageType in ['localStorage']
    context "when using #{storageType}", ->
      before ->
        Cumin.storageType = storageType

      describe '#add', ->
        keys = null

        before ->
          localStorage.setItem 'cumin.queue', JSON.stringify({})
          Cumin.add 'add',
            url: 'http://url'
            data:
              foo: 'bar'
            type: 'POST'
          keys = queueLength()

        it 'should add a request to the queue', ->
          expect(keys).to.have.length(1)
          expect(Cumin.queue()['add'].url).to.equal('http://url')
          expect(Cumin.queue()['add'].data['foo']).to.equal('bar')
          expect(Cumin.queue()['add'].type).to.equal('POST')

      describe '#remove', ->
        before ->
          Cumin.add 'remove', 'foo'
          Cumin.remove 'remove'

        it 'should remove the request from the queue', ->
          expect(Cumin.queue()['remove']).to.be.undefined

      describe '#clear', ->
        before ->
          Cumin.add 'clear', 'foo'
          Cumin.clear()

        it 'should clear the queue', ->
          expect(Cumin.queue()).to.be.empty

      describe '#queue', ->
        before ->
          Cumin.add 'queue'

        it 'should return an array', ->
          expect(Cumin.queue()).to.be.an('object')
