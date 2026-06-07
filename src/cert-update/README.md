
# Certificate Updater (cert-update)

Applies mounted corporate CA certificates to the container trust store

## Example Usage

```json
"features": {
    "ghcr.io/KingBain/devcontainer-features/cert-update:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| sourceCertificateDirectory | Optional directory containing mounted custom CA certificates to copy into the detected or explicit certDirectory before updating trust | string | - |
| certDirectory | Directory containing custom CA certificates. Defaults to the detected trust-store directory for the available CA update command. | string | - |
| required | Fail if no custom CA certificates are found | boolean | true |
| testCertificate | Generate a temporary test CA certificate for feature testing | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/KingBain/devcontainer-features/blob/main/src/cert-update/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
