/*
jquery.cumin
https://github.com/brewster1134/jquery.cumin
@version 0.0.4
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
        retryInterval: 600000
      },
      set: function(key, value) {
        return this.settings[key] = value;
      },
      setEvent: function(key, value) {
        return this.events[key] = value;
      },
      send: function(url, data, type) {
        var id, requestData;

        if (data == null) {
          data = {};
        }
        if (type == null) {
          type = 'GET';
        }
        id = new Date().getTime();
        requestData = {
          url: url,
          data: data,
          type: type,
          sendCount: 0
        };
        this.request(id, requestData);
        return requestData;
      },
      request: function(id, request) {
        var _this = this;

        return $.ajax({
          url: request.url,
          data: request.data,
          type: request.type,
          cache: false
        }).done(function() {
          return _this.remove(id);
        }).fail(function() {
          request.sendCount += 1;
          return _this.add(id, request);
        });
      },
      start: function() {
        var _this = this;

        this.stop();
        this.processQueue();
        this.interval = setInterval(function() {
          return _this.processQueue();
        }, this.settings.retryInterval);
        return Object.keys(this.queue()).length;
      },
      processQueue: function() {
        var id, request, _ref, _results;

        _ref = this.queue();
        _results = [];
        for (id in _ref) {
          request = _ref[id];
          _results.push(this.request(id, request));
        }
        return _results;
      },
      stop: function() {
        clearInterval(this.interval);
        this.interval = null;
        return Object.keys(this.queue()).length;
      },
      onQueueChange: function(type) {
        var _base;

        return typeof (_base = this.events).onQueueChange === "function" ? _base.onQueueChange(this.queue(), type) : void 0;
      },
      add: function(id, request) {
        this[this.storageType]['add'](id, request);
        return this.onQueueChange('add');
      },
      remove: function(id) {
        if (this.queue()[id] != null) {
          this[this.storageType]['remove'](id);
          this.onQueueChange('remove');
        }
        return id;
      },
      clear: function() {
        return this[this.storageType]['clear']();
      },
      queue: function() {
        return this[this.storageType]['queue']();
      },
      localStorage: {
        add: function(id, request) {
          var currentQueue;

          currentQueue = this.queue();
          currentQueue[id] = request;
          return localStorage.setItem('cumin.queue', JSON.stringify(currentQueue));
        },
        remove: function(id) {
          var currentQueue;

          currentQueue = this.queue();
          delete currentQueue[id];
          return localStorage.setItem('cumin.queue', JSON.stringify(currentQueue));
        },
        clear: function() {
          return localStorage.setItem('cumin.queue', JSON.stringify({}));
        },
        queue: function() {
          return JSON.parse(localStorage.getItem('cumin.queue'));
        }
      }
    };
    return Cumin.storageType = (typeof Modernizr !== "undefined" && Modernizr !== null ? Modernizr.localstorage : void 0) || !!window.localStorage ? (!window.localStorage.getItem('cumin.queue') ? localStorage.setItem('cumin.queue', JSON.stringify({})) : void 0, 'localStorage') : navigator.cookieEnabled ? 'cookies' : 'jsObject';
  })(window, jQuery);

}).call(this);
