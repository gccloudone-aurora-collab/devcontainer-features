<!-- markdownlint-disable-file MD041 -->

## Override Feature Install Order

_Comment from @KingBain_
This devcontainer feature was originally created by @bdsoha and the original can be found here <https://github.com/bdsoha/devcontainers> . I have only added some cleanup, cert verification and testing to his original idea

It is likely that you will need to have the custom CA certificate applied at an early stage of the installation build.
To override the order of installation, add the following to your `devcontainer.json` configuration:

> **Note** The values of `overrideFeatureInstallOrder` does not contain the feature's version tag.

```jsonc
// ...
"overrideFeatureInstallOrder": [
    "ghcr.io/kingbain/devcontainers/enhanced-custom-root-ca"
],
// ...
```

## Compatible Base Images

This feature was tested with the following base images _(and should work with all of their variants)_:

- `mcr.microsoft.com/devcontainers/base:ubuntu`
- `mcr.microsoft.com/devcontainers/base:debian`
- `mcr.microsoft.com/devcontainers/base:alpine`
