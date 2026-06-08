
# Enhanced Custom Root CA (enhanced-custom-root-ca)

🔒 Add a custom Root CA to your development environment

## Example Usage

```json
"features": {
    "ghcr.io/KingBain/devcontainer-features/enhanced-custom-root-ca:2": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| name | Name of the custom root CA | string | custom-root-ca.crt |
| source | Remote location *(or comma separated locations)* of the certificate in PEM format to be added | string | https://netfree.link/cacert/isp/018/ca.crt |
| fingerprints | Optional comma-separated list of SHA-256 fingerprints to verify the downloaded certificates against. | string | - |
| bundle | Create a certificate bundle of all applied CAs | boolean | true |
| verify | Verify the downloaded SSL certificate | boolean | true |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/KingBain/devcontainer-features/blob/main/src/enhanced-custom-root-ca/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
