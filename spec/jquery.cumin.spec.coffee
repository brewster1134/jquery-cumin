describe 'Cumin', ->
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
        Cumin.send 'send'

      after ->
        requestStub.restore()

      it 'should send a request', ->
        expect(requestStub).to.be.calledOnce

  context 'Private Methods', ->
    describe '#request', ->
      server = null
      addSpy = null
      removeSpy = null

      before ->
        server = sinon.fakeServer.create()
        addSpy = sinon.spy Cumin, 'add'
        removeSpy = sinon.spy Cumin, 'remove'

      after ->
        Cumin.clear()
        server.restore()
        addSpy.restore()
        removeSpy.restore()

      afterEach ->
        addSpy.reset()
        removeSpy.reset()

      context 'on success', ->
        before ->
          server.respondWith [200, {}, 'OK']

          Cumin.request 'requestSuccess',
            url: 'http://requestSuccess'
            data: {}
            type: 'GET'

          server.respond()

        it 'should not add request to the queue', ->
          expect(removeSpy).to.be.called

      context 'on error', ->
        before ->
          server.respondWith [500, {}, '']

          Cumin.request 'requestError',
            url: 'http://requestError'
            data: {}
            type: 'GET'
            sendCount: 1

          server.respond()

        it 'should add request to the queue', ->
          expect(addSpy).to.be.called

        it 'should increase the sendCount by 1', ->
          expect(Cumin.queue()['requestError'].sendCount).to.equal(2)

    describe '#start', ->
      stopSpy = null
      processQueueSpy = null

      before ->
        stopSpy = sinon.spy Cumin, 'stop'
        processQueueSpy = sinon.spy Cumin, 'processQueue'
        Cumin.start()

      it 'should call stop', ->
        expect(stopSpy).to.be.called

      it 'should call processQueue', ->
        expect(processQueueSpy).to.be.called

      it 'should set the interval', ->
        expect(Cumin.interval).to.exist

    describe '#processQueue', ->
      requestSpy = null

      before ->
        requestSpy = sinon.spy Cumin, 'request'
        Cumin.add 'fooId', 'fooRequest'
        Cumin.add 'barId', 'barRequest'
        Cumin.processQueue()

      it 'should call request for each send call', ->
        expect(requestSpy).to.be.calledTwice

    describe '#stop', ->
      before ->
        Cumin.interval = setInterval ->
        Cumin.stop()

      it 'should clear the interval', ->
        expect(Cumin.interval).to.be.null

    context 'when using events', ->
      describe 'onQueueChange', ->
        before ->
          Cumin.setEvent 'onQueueChange', sinon.spy()
          Cumin.add
            url: 'http://onQueueChange'

        it 'should be called when queue changes', ->
          expect(Cumin.events.onQueueChange).to.be.called

    for storageType in ['localStorage']
      context "when using #{storageType}", ->
        before ->
          Cumin.storageType = storageType

        describe '#add', ->
          before ->
            Cumin.clear()
            Cumin.add 'add',
              url: 'http://add'
              data:
                foo: 'bar'
              type: 'POST'

          it 'should add a request to the queue', ->
            expect(Object.keys(Cumin.queue())).to.have.length(1)
            expect(Cumin.queue()['add'].url).to.equal('http://add')
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
