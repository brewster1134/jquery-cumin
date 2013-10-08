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
      events: {
        onQueueChange: void 0
      },
      settings: {
        checkConnection: 5000,
        connectionUrl: window.location.href
      },
      set: function(key, value) {
        return this.settings[key] = value;
      },
      setEvent: function(key, value) {
        return this.events[key] = value;
      },
      isConnected: function() {
        var response;

        response = $.ajax({
          url: this.settings.connectionUrl,
          type: 'GET',
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
      onQueueChange: function(type) {
        var _base;

        return typeof (_base = this.events).onQueueChange === "function" ? _base.onQueueChange(this.queue(), type) : void 0;
      },
      queue: function() {
        return this[this.storageType]['queue']();
      },
      clear: function() {
        return this[this.storageType]['clear']();
      },
      add: function(url, data, type) {
        if (data == null) {
          data = {};
        }
        if (type == null) {
          type = 'GET';
        }
        this[this.storageType]['add'](url, data, type);
        return this.onQueueChange('add');
      },
      remove: function(id) {
        this[this.storageType]['remove'](id);
        return this.onQueueChange('remove');
      },
      localStorage: {
        queue: function() {
          return JSON.parse(localStorage.getItem('cumin.queue'));
        },
        clear: function() {
          return localStorage.setItem('cumin.queue', JSON.stringify({}));
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
    return Cumin.storageType = (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.localstorage : void 0) || !!window.localStorage ? (!window.localStorage.getItem('cumin.queue') ? localStorage.setItem('cumin.queue', JSON.stringify({})) : void 0, 'localStorage') : navigator.cookieEnabled ? 'cookies' : 'jsObject';
  })(window, jQuery);

}).call(this);
