# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive `.gitignore` file
- `.editorconfig` for consistent coding style
- MIT License
- Detailed documentation in `docs/` directory
- Optional module support in `ubuntu_setup.sh`:
  - `--golang` flag for Golang installation with Chinese mirrors
  - `--docker` flag for Docker installation with USTC mirror
  - `--all` flag to install all optional modules

### Changed
- **BREAKING**: `install.sh` now focuses solely on vim/nvim configuration
- **BREAKING**: Moved `install.sh` from root to `scripts/` directory
- **BREAKING**: Moved `ubuntu_setup.sh` from root to `scripts/` directory
- `install.sh` simplified to remove dependency installation
- `ubuntu_setup.sh` enhanced with:
  - Automatic environment file backup
  - Font cache refresh after font installation
  - Integrated tmux configuration installation
  - Shell compatibility for zoxide (bash/zsh detection)
- Shell environment variables updated:
  - Zoxide uses `--cmd j` flag for shorter alias
  - Golang proxy settings for Chinese users (GOPROXY, GOSUMDB)
  - UV package index using Aliyun mirror

### Deprecated
- None

### Removed
- **BREAKING**: Removed tmux installation and configuration from `install.sh`
- **BREAKING**: Removed ghostty installation and configuration from `install.sh`
- **BREAKING**: Removed system dependency installation from `install.sh`
- Deleted `install_tmux.sh` (functionality merged into `ubuntu_setup.sh`)

### Fixed
- Shell compatibility issues with zoxide initialization
- Path references after directory restructuring
- tmux configuration now properly integrated into system setup

### Security
- None

## [1.0.0] - 2025-01-11

### Added
- Initial release with vim/nvim configurations
- Tmux configuration
- Shell environment setup
- Basic installation scripts

### Original Features
- nvim/vim similar behavior
- stripwhitespace plugin for both vim/nvim
- tmux mini configuration
- Vundle plugin manager (legacy)
