#Changelog

## HEAD

### Enhancements

* COERCION: Added support for with `add`, `<<` and `merge` when mutating Set.
* COERCION: Added support for with `insert` when mutating Array.
* COERCION: Added support for with `merge!` and `store` when mutating Hash.
* VALIDATION: Support sending list as arguments as well as array in
  `exclude_from?` and `included_in?` predicates.
* VALIDATION: Automatically validate Array[SomeClass] instances if validation
  is supported.
* VALIDATION: Updated each_key and each_value error messages.

### Bugfixes

* Fix to disable coercion per attribute.

## v0.1.1

### Other changes

* Fix correct ruby version requirement in gemspec

## v0.1.0

This is the first version of Wardrobe released to RubyGems and considered beta.
