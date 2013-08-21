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
      settings: {
        checkConnection: 2000
      },
      isConnected: function() {
        var response;

        response = $.ajax({
          url: window.location.href,
          async: false,
          cache: false
        });
        return response.readyState === 4 && response.status === 200;
      },
      start: function() {
        var _this = this;

        return this.timeout = setTimeout(function() {
          var id, request, _ref;

          if (_this.isConnected()) {
            _ref = _this.queue();
            for (id in _ref) {
              request = _ref[id];
              $.ajax({
                url: request.url,
                data: request.data,
                type: request.type,
                success: function() {
                  return _this.remove(id);
                }
              });
            }
            return _this.start();
          }
        }, this.settings.checkConnection);
      },
      stop: function() {
        return clearTimeout(this.timeout);
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
      remove: function(id) {
        return this[this.storageType]['remove'](id);
      },
      localStorage: {
        queue: function() {
          return JSON.parse(localStorage.getItem('cumin.queue'));
        },
        add: function(url, data, type) {
          var currentQueue, id, newRequest;

          id = new Date().getTime();
          currentQueue = this.queue();
          newRequest = {
            url: url,
            data: data,
            type: type
          };
          currentQueue[id] = newRequest;
          return localStorage.setItem('cumin.queue', JSON.stringify(currentQueue));
        },
        remove: function(id) {
          var currentQueue;

          currentQueue = this.queue();
          delete currentQueue[id];
          return localStorage.setItem('cumin.queue', JSON.stringify(currentQueue));
        }
      }
    };
    return Cumin.storageType = (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.localstorage : void 0) || !!window['localStorage'] ? (localStorage.setItem('cumin.queue', JSON.stringify({})), 'localStorage') : navigator.cookieEnabled ? 'cookies' : 'jsObject';
  })(window, jQuery);

}).call(this);
