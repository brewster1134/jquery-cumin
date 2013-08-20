# jquery.cumin

A way to queue requests when offline.

## Dependencies
* [jQuery](http://jquery.com)

## Optional
* [Modernizr](http://modernizr.com)

## Demo

## Usage

#### Cumin.add

Adds a request to then end of the queue

* param url  [String] The URL to request
* param data [Object] A JS object of any neccessary data (useful for POST requests)
  * default: {}
* param type [String] 'GET' or 'POST'
  * default: 'GET'

```js
Cumin.add('http://url.com', {
  foo: 'bar'
}, 'POST');
```

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

Simply run `testem`.  Run `testem -g` for Growl support.

### To-Do

* Support Cookies as storage (if local storage isnt supported)
* Support plain JS object as storage (if cookies arent supported)
