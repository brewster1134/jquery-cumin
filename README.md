# jquery.cumin

A way to queue requests when offline.

## Dependencies
* [jQuery](http://jquery.com)

## Demo

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

* TBD
