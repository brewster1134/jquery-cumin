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
        expect(Cumin.queue()).to.be.an('array')

    describe '#add', ->
      before ->
        Cumin.add 'http://url',
          foo: 'bar'
        , 'POST'

      it 'should add a request to the queue', ->
        expect(Cumin.queue()).to.have.length(1)
        expect(Cumin.queue()[0].url).to.be.a('string')
