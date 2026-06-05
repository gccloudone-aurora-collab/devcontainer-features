# Dev Container Features

[![Tests](https://github.com/KingBain/devcontainer-features/actions/workflows/test.yaml/badge.svg)](https://github.com/KingBain/devcontainer-features/actions/workflows/test.yaml)

This repository contains my custom Dev Container Features.

You can learn more about Features at [https://containers.dev/implementors/features/](https://containers.dev/implementors/features/).

## Features

<!-- FEATURES_TABLE_START -->
| Feature | Description |
| ------- | ----------- |
| [cert-update](./src/cert-update) | Applies mounted corporate CA certificates to the container trust store |
| [databricks-cli](./src/databricks-cli) | Installs the Databricks CLI using the official Databricks setup script. |
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
    "ghcr.io/KingBain/devcontainer-features/cert-update:1": {},
    "ghcr.io/KingBain/devcontainer-features/databricks-cli:0": {},
    "ghcr.io/KingBain/devcontainer-features/enhanced-docker-in-docker:1": {}
  }
}
```
<!-- USAGE_EXAMPLE_END -->
