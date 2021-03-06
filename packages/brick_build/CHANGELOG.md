## Unreleased

## 1.1.0+3

* Ignore `unnecessary_non_null_assertion` and `invalid_null_aware_operator` in adapter generated code. If a repository is forced to a non-null value (`repository!`) subsequent access of the repository must not have an operator (`repository.` instead of `repository?`). Brick determines properties on a per-member basis, requiring a break in architecture to resolve subsquent access. These are linter warnings, not errors, and therefore they're safe to ignore for adapters.

## 1.1.0+2

* Remove `part` and `export` directives during build

## 1.1.0+1

* Do not generate null-safe return values in adapters if the member cannot be null. For example, this would remove `data['name'] == null ? null :` in the REST adapter function of field that cannot be null in Dart >=2.12

## 1.1.0

* **BREAKING CHANGE** removing  `testing.dart` in favor of new package `brick_build_test`. Please use `import 'package:brick_build_test/brick_build_test.dart'` instead. `source_gen_test` is not null safe, and testing shouldn't be in distributed packages anyway.

## 1.0.0

* Null safety

## 0.0.9

* If `fromGenerator` or `toGenerator` is declared, the field will be generated for deserializing and serializing adapters, respectively
* Strictly assign analyzer ahead of nullability release versions

## 0.0.8+2

* Override build methods

## 0.0.8+1

* Remove `getInheritedConcreteMap` from `fields_for_class.dart` as it's no longer used.

## 0.0.8

* Add method `ignoreCoderForField` to `SerdesGenerator`. This doesn't change existing functionality; it only moves it to an overridable method.

## 0.0.7

* Use assignable instead of super type comparison when checking for siblings to account for inherited classes (#55)
* Add ability to overwrite the nullable check for deserializing members

## 0.0.6

* Rename `ProviderSerializable` to `ProviderSerializableGenerator` to be more explicit
* Rename `SharedChecker#mapArgs` to `SharedChecker#typeArguments`

## 0.0.4

* Update for new [brick_core](https://github.com/greenbits/brick/tree/master/packages/brick_core) API on `Where`
* Move shareable methods from `OfflineFirstSerdesGenerator` to `SerdesGenerator`
* Constrain version of [brick_core](https://github.com/greenbits/brick/tree/master/packages/brick_core)
* Split code to separate projects: `rest_serdes` to [brick_rest_generators](https://github.com/greenbits/brick/tree/master/packages/brick_rest_generators), `sqlite_serdes` and subsequent SQLite builders to [brick_sqlite_generators](https://github.com/greenbits/brick/tree/master/packages/brick_sqlite_generators), and all OfflineFirst-specific logic to [brick_offline_first_with_rest_build](https://github.com/greenbits/brick/tree/master/packages/brick_offline_first_with_rest).
* `testing.dart` is available for useful testing methods
* This package is now a series of utilities and interfaces; it no longer produces generated code.

## 0.0.3

* Use `ConnectOfflineFirstWithRest`

## 0.0.2

* Uses `getDisplayString` instead of deprecated `name`
* Fix linter hints
