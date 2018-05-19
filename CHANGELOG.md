# logic Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## Fork from logic-zsh

Project forked from [logic-zsh/logic](https://github.com/logic-zsh/logic/) in order to add personal preferences without polluting.
Renamed to logic, to keep with the mathematical theme.

## [Unreleased]
### Added
- Background-jobs plugin as builtin plugin
- Support for left-prompt customization (contexts)
- Path and hostname as primary context plugins
- Git stash indicator (thanks [ev-agelos](https://github.com/ev-agelos)!)

### Changed
- Using `zsh-async` for right-prompt (git, hg, etc)

### Fixed
- Fix conflict count on non top-level directory

## 1.0.0 - 2017-04-05
### Added
- Change Log file
- Initial release features

[Unreleased]: https://github.com/logic-zsh/logic/compare/v1.0.0...HEAD
