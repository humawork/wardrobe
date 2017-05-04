# Atrs
[![Build Status](https://travis-ci.org/agensdev/atrs.svg?branch=master)](https://travis-ci.org/agensdev/atrs)
[![Code Climate](https://codeclimate.com/github/agensdev/atrs.svg)](https://codeclimate.com/github/agensdev/atrs)

Atrs is a library that simplifies creating ruby models with attributes and coercion. Atrs includes a multitude of plugins. See list of bundled plugins below. Atrs was made with inspiration from and years of using Virtus. Atrs aims at being easier to extend and include more tools out of the box.

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

## Composition

Atrs allow you to compose models based on multiple modules for reuse.
```ruby
module Name
  include Atrs
  attribute :first_name, String
  attribute :last_name, String
end

class Person
  include Name
  attribute :age, Integer
end
```

## Coercion

Coercion is enabled by default and works with most of the types available in Ruby.

Example:
```ruby
class User
  include Atrs
  attribute :id, Integer
  attribute :name, String
  attribute :status, Symbol
  attribute :friends, Array[User]
  attribute :interests, Hash[String => Symbol]
end

user = User.new(
  id: 1.1,
  name: :'Example User',
  status: 'active',
  friends: [
    {
      id: '0045',
      name: 'Another User',
      status: 'inactive'
    }
  ],
  interests: {
    'architecture' => 'medium',
    :sports => 'low',
    :travel => :high
  }
)

# <User:0x007fcc160851f8
#   @id=1,
#   @name="Example User",
#   @status=:active,
#   @friends=[
#     <User:0x007fcc16084b68
#       @id=45,
#       @name="Another User",
#       @status=:inactive,
#       @friends=[],
#       @interests={}>
#   ],
#   @interests={
#     "architecture"=>:medium,
#     "sports"=>:low,
#     "travel"=>:high
# }>
```

Coercion also works when mutating `Array`, `Hash` and `Set`. Based on the example above adding a friend to the friends array would coerce the given hash into a `User` object:

```ruby
user.friends << { id: '22', name: 'Added later' }
# => [
#  #<User:0x007fb242c0c960
#    @id=45,
#    @name="Another User",
#    @status=:inactive,
#    @friends=[],
#    @interests={}>,
#  #<User:0x007fb242bd66a8
#    @id=22,
#    @name="Added later",
#    @status=nil,
#    @friends=[],
#    @interests={}>
# ]
```
## Block syntax

Many plugins expose options for attributes. These can be enabled on each attribute needed, or you can use a block to enable for a group of attributes.

Per attribute syntax:
```ruby
class User
  include Atrs
  plugin :nil_if_empty

  attribute :first_name, String, nil_if_empty: true
  attribute :last_name, String, nil_if_empty: true
  attribute :friends, Array, nil_if_empty: true
end
User.new(first_name: '', last_name: '', friends: [])
# => #<User:0x007fb242b5e798 @friends=nil, @first_name=nil, @last_name=nil>
```

Block syntax:
```ruby
class User
  include Atrs
  plugin :nil_if_empty

  attributes do
    nil_if_empty true do
      attribute :first_name, String
      attribute :last_name, String
      attribute :friends, Array
    end
  end
end
User.new(first_name: '', last_name: '', friends: [])
# => #<User:0x007fb242b5e798 @friends=nil, @first_name=nil, @last_name=nil>
```

## Plugins

Atrs comes with numerous plugins and aims at making it easy to write your own.

|Name               |Exposed options      |Development state  |Description       |
|-------------------|---------------------|-------------------|------------------|
|validation         |`validates`          |POC                |dry-validation inspired validations for your attributes|
|immutable          |`immutable`          |BETA               |makes your modle immutable. Exposes a #mutate method that will return a new object|
|dirty_tracker      |`track`              |BETA               |tracks instances and exposes a #_changed? method|
|default            |`default`            |BETA               |default values for attributes|
|presenter          |                     |POC                |presents your instance as a hash|
|configurable       |                     |BETA               |allows you to add class level immutable configuration to your modles|
|nil_if_empty       |`nil_if_empty`       |BETA               |
|nil_if_zero        |`nil_if_zero`        |BETA               |
|alias_setters      |`alias_setter(Array)`|BETA               |
|json_initializer   |                     |POC                |initialize your model with a json string|
|html_initializer   |                     |POC                |initialize your model with a html string|
|xml_initializer    |                     |NOT IMPLEMENTED    |initialize your model with a xml string|
|optional_setter    |`setter`             |BETA               |disable the setter|
|optional_getter    |`getter`             |BETA               |disable the getter|

## Goals

Atrs should:

* be faster than Virtus
* have no dependencies (plugins may)
* not pollute the instance level with any methods other than ones prefixed with `_`
* should be immutable in the config layer allowing subclasses or singleton classes to modify the setup
* include a plugin system
* simplify coercions through refinements
