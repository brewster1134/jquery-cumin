/*
jquery.cumin
https://github.com/brewster1134/jquery.cumin
@version 0.0.1
@author Ryan Brewster (@brewster1134)
*/


(function() {
  (function(window, $) {
    window.console || (window.console = {
      log: function() {}
    });
    window.Cumin = {
      isConnected: function() {
        var response;

        response = $.ajax({
          url: window.location.href,
          async: false,
          cache: false
        });
        return response.readyState === 4 && response.status === 200;
      },
      queue: function() {
        return this[this.storageType]['queue']();
      },
      add: function(url, data, type) {
        if (data == null) {
          data = {};
        }
        if (type == null) {
          type = 'GET';
        }
        return this[this.storageType]['add'](url, data, type);
      },
      localStorage: {
        queue: function() {
          return JSON.parse(localStorage.getItem('cumin.queue'));
        },
        add: function(url, data, type) {
          var currentQueue, newRequest;

          currentQueue = Cumin.queue();
          newRequest = {
            id: new Date().getTime(),
            url: url,
            data: data,
            type: type
          };
          currentQueue.push(newRequest);
          localStorage.setItem('cumin.queue', JSON.stringify(currentQueue));
          return newRequest;
        }
      }
    };
    return Cumin.storageType = (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.localstorage : void 0) || !!window['localStorage'] ? (localStorage.setItem('cumin.queue', JSON.stringify([])), 'localStorage') : navigator.cookieEnabled ? 'cookies' : 'jsObject';
  })(window, jQuery);

}).call(this);
