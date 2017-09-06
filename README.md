# Wardrobe
[![Build Status](https://travis-ci.org/agensdev/wardrobe.svg?branch=master)](https://travis-ci.org/agensdev/wardrobe)
[![Code Climate](https://codeclimate.com/github/agensdev/wardrobe.svg)](https://codeclimate.com/github/agensdev/wardrobe)
[![Test Coverage](https://codeclimate.com/github/agensdev/wardrobe/badges/coverage.svg)](https://codeclimate.com/github/agensdev/wardrobe/coverage)
[![Gem Version](https://badge.fury.io/rb/wardrobe.svg)](https://rubygems.org/gems/wardrobe)

Wardrobe is a gem that simplifies creating Ruby objects with attributes. Wardrobe bundles a multitude of plugins. See [list](#bundled-plugins) below.

## Requirements

Wardrobe requires Ruby 2.4.0 or later. Read more about why [here](#ruby-24).
JRuby should be supported once [9.2.0.0](https://github.com/jruby/jruby/milestone/53) is released

## Documentation
[Documentation for Wardrobe](https://agensdev.github.io/wardrobe/getting-started/about/)

## Installation

```
gem install wardrobe
```

## Getting started

```ruby
require 'wardrobe'

class User
  include Wardrobe
  attribute :name, String
end

User.new(name: 'Wardrobe User')
```

[Read more here](https://agensdev.github.io/wardrobe/getting-started/about/)

## Goals

Wardrobe should:

* be faster than Virtus
* have no dependencies (plugins may)
* not pollute the instance level with any methods other than ones prefixed with `_`
* should be immutable in the config layer allowing subclasses or singleton classes to modify the config
* be easy to extend with plugins
* simplify coercions through refinements

## Ruby 2.4

When working on the first "Proof of Concept" for Wardrobe I wanted to use refinements for coercion. This was right before Ruby 2.4 was released that added support for using Kernel#send to call a method defined in a refined class. This was needed to get my first POC working and is why Wardrobe requires ruby 2.4 or above.
