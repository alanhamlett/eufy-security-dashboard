# Change Log
All notable changes to this project will be documented in this file.

## Unreleased

## 1.3.1
Released on 2017-10-01.

### Fixed
* Issue where apps could not be summited to Appstore. [#90](https://github.com/naoty/Timepiece/pull/90)

## 1.3.0
Released on 2017-09-30.

### Added
* Swift 4 support

## 1.2.0
Released on 2017-04-30.

### Added
* Support Swift Package Manager. [#83](https://github.com/naoty/Timepiece/pull/83)
* `truncated(_:)`, which creates a `Date` instance by truncating the components. [#82](https://github.com/naoty/Timepiece/pull/82)
* `truncated(from:)`, which creates a `Date` instance by truncating the components from a given component. [#82](https://github.com/naoty/Timepiece/pull/82)

### Fixed
* Rename `string(inDateStyle:andTimeStyle:)` to `stringIn(dateStyle:timeStyle:)`.
* Rename `dateInISO8601Format(withOptions:)` to `dateInISO8601Format(with:)`.

## 1.1.0
Released on 2017-01-06.

### Added
* `changed(year:month:day:hour:minute:second:nanosecond:)`, which creates a `Date` instance by changing receiver's date components. [#77](https://github.com/naoty/Timepiece/pull/77)
* `changed(weekday:)`, which creates a `Date` instance by changing receiver's weekday. [#77](https://github.com/naoty/Timepiece/pull/77)

## 1.0.2
Released on 2016-12-20.

### Fixed
* Fix testDateInISO8601Format() availability. [#74](https://github.com/naoty/Timepiece/pull/74).
* Specify Swift version for the compilation of watchOS target. [#79](https://github.com/naoty/Timepiece/pull/79).

## 1.0.1
Released on 2016-11-05.

### Changed
* Create instance of date components instead of mutable variables. [#67](https://github.com/naoty/Timepiece/pull/67).

### Fixed
* Fix App Store submission issue. [#71](https://github.com/naoty/Timepiece/pull/71).

## 1.0.0
Released on 2016-10-30.

### Added
* New initializers for `Date`.
* `+` and `-` between `DateComponents`
* Methods to format `Date` with date style.
* A method to format `DateComponents` with units style.
* A method to parse `String` using `ISO8601DateFormatter`.

### Removed
* `Date.date()` constructor methods.
* `Duration`.
* Time zone support for each `Date`.
* Properties to get beginning and end of periods such as `beginningOfYear`, `endOfMonth`.
* `change()`.

### Changed
* For `Int`, `year`, `month` and so on creates new `DateComponents` instance instead of `Duration`.
