###
jquery.cumin
https://github.com/brewster1134/jquery.cumin
@version 0.0.5
@author Ryan Brewster (@brewster1134)
###

((window, $) ->
  window.console ||= { log: -> }
  window.Cumin =
    events:
      onQueueChange: undefined
    settings:
      retryInterval: 600000

    # PUBLIC METHODS
    #
    set: (key, value) ->
      @settings[key] = value

    setEvent: (key, value) ->
      @events[key] = value

    # Prepares and sends a request
    #
    # @param url  [String] The URL to request
    # @param data [Object] A JS object of any neccessary data (useful for POST requests)
    #   default: {}
    # @param type [String] 'GET' or 'POST'
    #   default: 'GET'
    #
    send: (url, data = {}, type = 'GET') ->
      id = new Date().getTime()
      requestData =
        url: url
        data: data
        type: type
        sendCount: 0

      @request id, requestData

      return requestData

    # PRIVATE METHODS
    #

    # Makes a request, or queues the request if there is a failure
    #
    request: (id, request) ->
      $.ajax
        url: request.url
        data: request.data
        type: request.type
        cache: false
      .done =>
        @remove id
      .fail =>
        request.sendCount += 1
        @add id, request

    start: ->
      @stop()
      @processQueue()
      @interval = setInterval =>
        @processQueue()
      , @settings.retryInterval
      return Object.keys(@queue()).length # return queue length

    processQueue: ->
      for id, request of @queue()
        @request id, request

    stop: ->
      clearInterval @interval
      @interval = null
      return Object.keys(@queue()).length # return queue length

    # EVENTS
    #
    onQueueChange: (type) -> @events.onQueueChange? @queue(), type

    #
    # SHORTCUT METHODS TO STORAGE SPECIFIC METHODS
    #

    # Adds a request to the queue
    # @param id [String] the key name of the request in the queue
    #
    add: (id, request) ->
      @[@storageType]['add'](id, request)
      @onQueueChange 'add'

    # Removes a request from the queue
    # @param id [String] the key name of the request in the queue
    #
    remove: (id) ->
      if @queue()[id]?
        @[@storageType]['remove'](id)
        @onQueueChange 'remove'
      return id

    # Clears the queue
    #
    clear: -> @[@storageType]['clear']()

    # Returns the current queue
    #
    queue: -> @[@storageType]['queue']()

    #
    # STORAGE TYPE SPECIFIC METHODS
    #
    localStorage:
      add: (id, request) ->
        currentQueue = @queue()
        currentQueue[id] = request

        # Save updated queue to localStorage
        localStorage.setItem 'cumin.queue', JSON.stringify(currentQueue)

      remove: (id) ->
        currentQueue = @queue()

        delete currentQueue[id]

        localStorage.setItem 'cumin.queue', JSON.stringify(currentQueue)

      clear: ->
        localStorage.setItem 'cumin.queue', JSON.stringify({})

      queue: ->
        JSON.parse localStorage.getItem 'cumin.queue'

    # cookies:

    # jsObject:

  # Sets the best available storage type
  Cumin.storageType = if Modernizr?.localstorage || !!window.localStorage
    unless window.localStorage.getItem 'cumin.queue'
      localStorage.setItem 'cumin.queue', JSON.stringify({})
    'localStorage'
  else if navigator.cookieEnabled
    'cookies'
  else
    'jsObject'

) window, jQuery
