$ ->
  updateQueue = ->
    # update count
    $('#q-count span').text Object.keys(Cumin.queue()).length
      
    # update list
    $('#q').empty()
    $.each Cumin.queue(), (k, v) ->
      $('#q').append $('<li></li>').text(v)

  $('form').on 'submit', (e) ->
    e.preventDefault()
    id = new Date().getTime()
    Cumin.add id, $(@).serialize(), 'POST'
    updateQueue()
    
  $('#start-q').on 'click', (e) ->
    e.preventDefault()
    Cumin.start()
    updateQueue()

  $('#clear-q').on 'click', (e) ->
    e.preventDefault()
    Cumin.clear()
    updateQueue()