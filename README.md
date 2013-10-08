# jquery.cumin
A way to queue requests when offline.

## Usage

### Dependencies
* [jQuery](http://jquery.com)

### Optional
* [Modernizr](http://modernizr.com)

### Methods

#### Cumin.send
Adds a request to the queue

* param url     [String]  The URL to request
* param data    [Object]  A JS object of any neccessary data (useful for POST requests)
  * default: {}
* param method  [String]  Http request methods ('GET', 'POST', etc.)
  * default: 'GET'

```js
Cumin.send('http://url.com', {
  foo: 'bar'
}, 'POST');
```

#### Cumin.set & Cumin.setEvent
Sets events and settings

* param key   [String]  The name of the setting or event
* param value [String]  The value of the setting or event

```js
Cumin.set('foo', 'bar');
Cumin.setEvent('onFoo', 'bar');
```

##### Supported Settings
* checkConnectionDelay  [Integer] Time in milliseconds between checking if the app is connected to the internet or not
  * default: 600000                 # 10 minutes
* checkConnectionUrl    [String]  The url to make a GET request to check if the app is online.
  * default: window.location.href   # the url in the address bar of the browser

##### Supported Events
* onQueueChange [Function] Function to be run after any change of the queue.

###### Accepted Arguments:
* queue   [Object]  The entire queue
* type    [String]  The type of change made to the queue (add/remove)

## Development

### Dependencies
* Ruby 1.9.3
  * [rbenv](https://github.com/sstephenson/rbenv) and [ruby-build](https://github.com/sstephenson/ruby-build)
    * `rbenv install 1.9.3`
* Bundler Gem
  * `gem install bundler`
* Bundled Gems
  * `bundle install`
* Node.js & NPM
  * OS X
     * [HomeBrew](http://mxcl.github.io/homebrew/) _recommended_
       * 'brew install node'
* [Testem](https://github.com/airportyh/testem)
  * `npm install testem -g`

### Optional
* [PhantomJS](http://phantomjs.org)
  * OS X
     * [HomeBrew](http://mxcl.github.io/homebrew/) _recommended_
       * `brew install phantomjs`
* [Growl](http://growl.info/downloads)
  * OS X 10.8

### Compiling
Do **NOT** modify any `.js` files!  Modify the coffee files in the `src` directory.  Guard will watch for changes and compile them to the `lib` directory.

`bundle exec guard`

## Testing
Simply run `testem`.

Run `testem -g` for Growl support.

### To-Do
* Demo
* Support Cookies as storage (if local storage isnt supported)
* Support plain JS object as storage (if cookies arent supported)
* If x amount of failures, remove from queue? move out of queue?
* only return public methods
* use setInterval instead of setTimeout
