#Changelog

## HEAD
* Improved support for plugins in modules.
* CONFIGURABLE: Added before_update and after_update callbacks
* CONFIGURABLE: Support validation plugin

### Enhancements

* COERCION: Added support for with `add`, `<<` and `merge` when mutating Set.
* COERCION: Added support for with `insert` when mutating Array.
* COERCION: Added support for with `merge!` and `store` when mutating Hash.
* COERCION: Added support for Proc class.
* VALIDATION: Support sending list as arguments as well as array in
  `exclude_from?` and `included_in?` predicates.
* VALIDATION: Automatically validate Array[SomeClass] instances if validation
  is supported.
* VALIDATION: Updated each_key and each_value error messages.
* EQUALITY: Changed `include_in_equality` option to  `exclude_from_equality`
* Support loading plugin as both string and symbol.

### Bugfixes

* COERCION: Fix to disable coercion per attribute.
* EQUALITY: Return false if classes don't match

## v0.1.1

### Other changes

* Fix correct ruby version requirement in gemspec

## v0.1.0

This is the first version of Wardrobe released to RubyGems and considered beta.
