[![Build Status](https://travis-ci.org/uu59/masque.png?branch=master)](https://travis-ci.org/uu59/masque)
[![Coverage Status](https://coveralls.io/repos/uu59/masque/badge.png?branch=master)](https://coveralls.io/r/uu59/masque)
[![Code Climate](https://codeclimate.com/github/uu59/masque/badges/gpa.svg)](https://codeclimate.com/github/uu59/masque)
[![Gem Version](https://badge.fury.io/rb/masque.svg)](http://badge.fury.io/rb/masque)

# Masque

<a href="http://ja.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB:Noh_mask02.jpg"><img src="http://upload.wikimedia.org/wikipedia/commons/b/bd/Noh_mask02.jpg" alt="女面" /></a>

Masque is a browser emulated crawler builder wrapping [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) and [poltergeist](https://github.com/jonleighton/poltergeist).

## Installation

You need Xvfb and QT libraries before installing Masque gem.

- <https://github.com/leonid-shevtsov/headless#installation>
- <https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit>

On Debian/Ubuntu:

    $ sudo apt-get install libqt4-dev xvfb libicu48 ttf-ubuntu-font-family
    $ gem install masque


On Mac OS X (assumes you have [Homebrew](http://brew.sh) installed):

    $ brew install qt
    $ gem install masque

## Usage

Easy crawling websites they required JavaScript.

    require "masque"
    m = Masque.new(:display => 99, :driver => :webkit) # or :driver => :poltergeist
    m.run do
      # Capybara::DSL syntax
      # https://github.com/jnicklas/capybara#the-dsl

      visit "http://www.google.com/"
      fill_in("q", :with => "capybara")
      find('*[name="btnG"]').click

      titles = evaluate_script <<-JS
        (function(){
          var titles = Array.prototype.map.call(
            document.querySelectorAll('h3 a'),
            function(a) {
              return a.innerText;
            }
          );

          return titles;
        })();
      JS
      puts titles.join("\n")
    end

more examples are available in examples/ directory.

## TODO

- Impl useful DSL
- Respect driver specific features/options


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
