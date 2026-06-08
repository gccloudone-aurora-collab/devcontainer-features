<!-- markdownlint-disable-file MD041 -->

## 💡 Usage Guide: Corporate Root Certificates

This feature is designed for developers working on corporate desktops or virtual machines situated behind strict corporate proxies or firewalls. These environments often intercept SSL/TLS traffic, which will cause standard development tools (like `npm`, `pip`, `curl`, or `git`) inside your Dev Container to fail with "SSL Certificate Verification" errors.

To fix this, you must push your corporate Root CA certificate from your host machine into the Dev Container so the container's operating system trusts your corporate proxy.

### How to use this feature

Using this feature requires a three-step process:

1. **Mount** a folder containing your host's corporate certificates into the container.
2. **Configure** this feature to read from that mounted folder and update the container's trust store.
3. **Enforce** the installation order so this feature runs _before_ any other features.

#### Step 1: Save your corporate certificate

Ensure your corporate root certificate is saved on your host machine in `.crt` format. Put it in a dedicated folder, for example:

- **Windows/Linux**: `~/.certs/corporate.crt`
- **macOS**: `/Users/username/.certs/corporate.crt`

#### Step 2 & 3: Update your `devcontainer.json`

You need to mount the folder, add the feature, and specifically tell the Dev Container to install `cert-update` first.

If you do not set `overrideFeatureInstallOrder`, other features (like installing Python, Node, or Docker) might try to run first, and their installation scripts will fail because the corporate proxy is not trusted yet.

```jsonc
{
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",

  // 1. Mount the folder containing your host's certificates into the container
  "mounts": [
    {
      "source": "${localEnv:HOME}/.certs",
      "target": "/tmp/host-certs",
      "type": "bind",
      "consistency": "cached",
    },
  ],

  "features": {
    // 2. Point the cert-update feature at the mounted folder
    "ghcr.io/KingBain/devcontainer-features/cert-update:1": {
      "sourceCertificateDirectory": "/tmp/host-certs",
      "required": false,
    },
    "ghcr.io/devcontainers/features/python:1": {},
  },

  // 3. FORCE the cert-update feature to run before anything else!
  "overrideFeatureInstallOrder": [
    "ghcr.io/KingBain/devcontainer-features/cert-update",
  ],
}
```
