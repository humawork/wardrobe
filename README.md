# Atrs
[![Build Status](https://travis-ci.org/agensdev/atrs.svg?branch=master)](https://travis-ci.org/agensdev/atrs)
[![Code Climate](https://codeclimate.com/github/agensdev/atrs.png)](https://codeclimate.com/github/agensdev/atrs)


Atrs was inspired by Virtus. It offers a plugin system with multiple included plugins like Immutable, Configurable and Validations. See wiki for full list.

## Requirements

Atrs requires Ruby 2.4.0+. Support for older versions of ruby is not planned.

## Installation

```
gem install atrs (Not available yet)
```

## Getting started

```ruby
class User
  include Atrs
  attribute :name, String
end

User.new(name: 'Atrs User')
```



Atrs should:

* be faster than Virtus
* have no dependencies (plugins may)
* not pollute the instance level with any methods other than ones prefixed with `_`
* should be immutable in the config layer allowing subclasses or singleton classes to modify the setup
* include a plugin system
* simplify coercions through refinements
