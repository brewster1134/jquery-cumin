$(function() {
  var updateQueue;
  updateQueue = function() {
    $('#q-count span').text(Object.keys(Cumin.queue()).length);
    $('#q').empty();
    return $.each(Cumin.queue(), function(k, v) {
      return $('#q').append($('<li></li>').text(v));
    });
  };
  $('form').on('submit', function(e) {
    var id;
    e.preventDefault();
    id = new Date().getTime();
    Cumin.add(id, $(this).serialize(), 'POST');
    return updateQueue();
  });
  $('#start-q').on('click', function(e) {
    e.preventDefault();
    Cumin.start();
    return updateQueue();
  });
  return $('#clear-q').on('click', function(e) {
    e.preventDefault();
    Cumin.clear();
    return updateQueue();
  });
});
