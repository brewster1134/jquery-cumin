# jquery.cumin
A way to queue requests when offline.

## Usage

#### Dependencies
* [jQuery](http://jquery.com)

#### Optional
* [Modernizr](http://modernizr.com)

#### Quick Examples
_Queing form POST requests_
```coffee
$('#form).submit (e) ->
  e.preventDefault()
  Cumin.send @attr('action'), @serialize(), 'POST'
```
#### Methods

###### Cumin.send
Adds a request to the queue

* param url     [String]  The URL to request
* param data    [Object]  A JS object of any neccessary data (useful for POST requests)
  * default: {}
* param method  [String]  Http request methods ('GET', 'POST', etc.)
  * default: 'GET'

```coffee
Cumin.send 'http://url.com',
  foo: 'bar'
, 'POST'
```

###### Cumin.set & Cumin.setEvent
Sets events and settings

* param key   [String]  The name of the setting or event
* param value [String]  The value of the setting or event

```coffee
Cumin.set 'foo', 'bar'
Cumin.setEvent 'onFoo', 'bar'
```

###### Supported Settings
* retryInterval  [Integer] Time in milliseconds between checking if the app is connected to the internet or not
  * default: 600000                 # 10 minutes

###### Supported Events
* onQueueChange [Function] Function to be run after any change of the queue.

Accepted Arguments:
* queue   [Object]  The entire queue
* type    [String]  The type of change made to the queue (add/remove)

## Development

#### Dependencies
* coffeescript `npm install -g coffeescript`
* node `brew install node`
* testem `npm install -g testem`
* yarn `brew install yarn`

Run `yarn` to install remaining dependencies

#### Optional
* phantomjs `brew install phantomjs`

#### Compiling
Do **NOT** modify any `.js` files!  Modify the coffee files in the `src` and `spec` directories.  Testem will watch for changes and compile them to the `lib` and `.tmp` directories.

#### Testing
Simply run `testem`

## To-Do
* Demo
* Support Cookies as storage (if local storage isnt supported)
* Support plain JS object as storage (if cookies arent supported)
* If x amount of failures, remove from queue? move out of queue?
* only return public methods
