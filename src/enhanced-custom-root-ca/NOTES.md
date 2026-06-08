<!-- markdownlint-disable-file MD041 -->

## Override Feature Install Order

_Comment from @KingBain_

This devcontainer feature was originally created by @bdsoha. The original can be found here: https://github.com/bdsoha/devcontainers.

I have added cleanup, certificate fingerprint verification, and testing to the original idea.

It is likely that you will need to have the custom CA certificate applied at an early stage of the installation build.

To override the order of installation, add the following to your `devcontainer.json` configuration:

> **Note**
> The values in `overrideFeatureInstallOrder` do not include the feature's version tag.

```jsonc
// ...
"overrideFeatureInstallOrder": [
    "ghcr.io/kingbain/devcontainers/enhanced-custom-root-ca"
],
// ...
```

## Certificate Fingerprints

The `fingerprints` option can be used to verify that the downloaded certificate is the certificate you expected.

This is separate from HTTPS/TLS download validation. Fingerprint verification checks the SHA-256 fingerprint of the certificate file after it has been downloaded.

### Single Certificate

When downloading one certificate, provide one SHA-256 fingerprint:

```jsonc
"features": {
    "ghcr.io/kingbain/devcontainer-features/enhanced-custom-root-ca:2": {
        "source": "https://example.com/root-ca.crt",
        "fingerprints": "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99"
    }
}
```

### Multiple Certificates

When downloading multiple certificates, provide a comma-separated list of certificate URLs in `source`.

If you want to verify each certificate, provide a comma-separated list of SHA-256 fingerprints in the same order.

```jsonc
"features": {
    "ghcr.io/kingbain/devcontainer-features/enhanced-custom-root-ca:2": {
        "name": "custom.sub.crt",
        "source": "https://example.com/root-ca-1.crt,https://example.com/root-ca-2.crt",
        "fingerprints": "AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99,11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00"
    }
}
```

The first fingerprint is used to verify the first certificate URL. The second fingerprint is used to verify the second certificate URL.

```text
source[1]       -> fingerprints[1]
source[2]       -> fingerprints[2]
source[3]       -> fingerprints[3]
```

If a fingerprint does not match, the feature installation fails.

### Getting a Certificate Fingerprint

You can get the SHA-256 fingerprint of a certificate with OpenSSL:

```sh
openssl x509 -in root-ca.crt -noout -sha256 -fingerprint
```

The output will look similar to this:

```text
sha256 Fingerprint=AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99
```

Use the value after `sha256 Fingerprint=`.

## Compatible Base Images

This feature was tested with the following base images _(and should work with all of their variants)_:

- `mcr.microsoft.com/devcontainers/base:ubuntu`
- `mcr.microsoft.com/devcontainers/base:debian`
- `mcr.microsoft.com/devcontainers/base:alpine`
