###
jquery.cumin
https://github.com/brewster1134/jquery.cumin
@version 0.0.1
@author Ryan Brewster (@brewster1134)
###

((window, $) ->
  window.console ||= { log: -> }
  window.Cumin =
    settings:
      checkConnection: 2000

    # Checks if the script is on or offline
    #
    isConnected: ->
      response = $.ajax
        url: window.location.href
        async: false
        cache: false

      response.readyState == 4 && response.status == 200

    start: ->
      @timeout = setTimeout =>
        if @isConnected()
          for id, request of @queue()
            $.ajax
              url: request.url
              data: request.data
              type: request.type
              success: =>
                @remove id
          @start()
      , @settings.checkConnection

    stop: ->
      clearTimeout @timeout

    #
    # SHORTCUT METHODS TO STORAGE SPECIFIC METHODS
    #

    # Returns the current queue
    #
    queue: -> @[@storageType]['queue']()

    # Adds a request to the queue
    #
    # @param url  [String] The URL to request
    # @param data [Object] A JS object of any neccessary data (useful for POST requests)
    #   default: {}
    # @param type [String] 'GET' or 'POST'
    #   default: 'GET'
    #
    add: (url, data = {}, type = 'GET') -> @[@storageType]['add'](url, data, type)

    # Removes a request from the queue
    # @param id [String] the key name of the request in the queue
    #
    remove: (id) -> @[@storageType]['remove'](id)

    #
    # STORAGE TYPE SPECIFIC METHODS
    #
    localStorage:
      queue: ->
        JSON.parse localStorage.getItem 'cumin.queue'

      add: (url, data, type) ->
        id = new Date().getTime()
        currentQueue = @queue()
        newRequest =
          url: url
          data: data
          type: type

        currentQueue[id] = newRequest

        # Save updated queue to localStorage
        localStorage.setItem 'cumin.queue', JSON.stringify(currentQueue)

      remove: (id) ->
        currentQueue = @queue()

        delete currentQueue[id]

        localStorage.setItem 'cumin.queue', JSON.stringify(currentQueue)

    # cookies:

    # jsObject:


  # Sets the best available storage type
  Cumin.storageType = if Modernizr?.localstorage || !!window['localStorage']
    localStorage.setItem 'cumin.queue', JSON.stringify({})
    'localStorage'
  else if navigator.cookieEnabled
    'cookies'
  else
    'jsObject'

) window, jQuery
