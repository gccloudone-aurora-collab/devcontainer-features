# Dev Container Features

[![Release](https://github.com/KingBain/devcontainer-features/actions/workflows/release-please.yaml/badge.svg)](https://github.com/KingBain/devcontainer-features/actions/workflows/release-please.yaml) [![CodeQL](https://github.com/KingBain/devcontainer-features/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/KingBain/devcontainer-features/actions/workflows/github-code-scanning/codeql)

This repository contains my custom Dev Container Features.

You can learn more about Features at [https://containers.dev/implementors/features/](https://containers.dev/implementors/features/).

## Features

<!-- FEATURES_TABLE_START -->
| Feature | Description |
| ------- | ----------- |
| [enhanced-custom-root-ca](./src/enhanced-custom-root-ca) | 🔒 Add a custom Root CA to your development environment |
| [enhanced-docker-in-docker](./src/enhanced-docker-in-docker) | Create child containers *inside* a container, independent from the host's docker instance. Installs Docker extension in the container along with needed CLIs. |
<!-- FEATURES_TABLE_END -->

## Usage

To reference one or more Features from this repository, add them to your `devcontainer.json`. Each Feature has a `README.md` under its folder with details and options.

<!-- USAGE_EXAMPLE_START -->
```jsonc
{
  "name": "my-project-devcontainer",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/KingBain/devcontainer-features/enhanced-custom-root-ca:4": {},
    "ghcr.io/KingBain/devcontainer-features/enhanced-docker-in-docker:1": {}
  }
}
```
<!-- USAGE_EXAMPLE_END -->
