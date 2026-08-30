# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Characters beyond the Basic Multilingual Plane (every emoji, e.g. U+1F916) did not survive `put_string` / `add_string` / `json_string`: the underlying ejson escaper wrote a five-digit `\u1F916`, which its own decoder read back as U+1F91 followed by `6`. `SIMPLE_JSON_OBJECT.put_string`'s `value_stored` postcondition caught it (2026-08-29). All string text is now escaped by the new `SIMPLE_JSON_TEXT` (non-ASCII as raw UTF-8 per RFC 8259) and never by ejson.
- Surrogate-pair escapes (`\ud83e\udd16`, as emitted by Python's `json`, older Java and `JSON.stringify`) decoded to two lone surrogates; they are now combined into the one character on every `string_item` / `as_string_32`.

### Changed
- Testing config updates, AutoTest fixes, .gitignore cleanup
- Migrate to simple_testing library
- Remove redundant result_not_void postconditions
- Add as_json and as_json_32 output features to SIMPLE_JSON_VALUE
- Add friction-free JSON helper methods and serialization pattern
- Added in JSON1 for SQLite
- Fixed obsolete calls using Claude CLI
- Readme.MD update
- json array preconditions/constants
- New constants class and magic-number replacement(s) system wide

## [1.0.0] - 2025-12-08

### Added
- Initial release
- Core functionality implemented
- Test suite with comprehensive coverage
- Documentation and examples

[Unreleased]: https://github.com/simple-eiffel/simple_json/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/simple-eiffel/simple_json/releases/tag/v1.0.0
