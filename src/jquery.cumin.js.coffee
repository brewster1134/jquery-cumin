###
jquery.cumin
https://github.com/brewster1134/jquery.cumin
@version 0.0.1
@author Ryan Brewster (@brewster1134)
###

((window, $) ->
  window.console ||= { log: -> }
  window.Cumin =

    # Checks if the script is on or offline
    #
    isConnected: ->
      response = $.ajax
        url: window.location.href
        async: false
        cache: false

      response.readyState == 4 && response.status == 200

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

    #
    # STORAGE TYPE SPECIFIC METHODS
    #
    localStorage:
      queue: ->
        JSON.parse localStorage.getItem 'cumin.queue'

      add: (url, data, type) ->
        currentQueue = Cumin.queue()
        newRequest =
          id: new Date().getTime()
          url: url
          data: data
          type: type

        currentQueue.push newRequest

        # Save updated queue to localStorage
        localStorage.setItem 'cumin.queue', JSON.stringify(currentQueue)

        return newRequest

    # cookies:

    # jsObject:

  # Sets the best available storage type
  Cumin.storageType = if Modernizr?.localstorage || !!window['localStorage']
    localStorage.setItem 'cumin.queue', JSON.stringify([])
    'localStorage'
  else if navigator.cookieEnabled
    'cookies'
  else
    'jsObject'

) window, jQuery
