# Enhanced Docker (Docker-in-Docker) (enhanced-docker-in-docker)

Create child containers *inside* a container, independent from the host's docker instance. Installs Docker extension in the container along with needed CLIs. **Includes enhanced support for corporate proxies and custom Root CA injection into nested BuildKit/Buildx builders.**

## Example Usage

```json
"features": {
    "ghcr.io/kingbain/devcontainer-features/enhanced-docker-in-docker:latest": {
        "caCertsMount": true
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Docker/Moby Engine version. (Availability can vary by OS version.) | string | latest |
| moby | Install OSS Moby build instead of Docker CE | boolean | true |
| mobyBuildxVersion | Install a specific version of moby-buildx when using Moby | string | latest |
| dockerDashComposeVersion | Default version of Docker Compose (latest, v1, v2 or none) | string | latest |
| azureDnsAutoDetection | Allow automatically setting the dockerd DNS server when the installation script detects it is running in Azure | boolean | true |
| dockerDefaultAddressPool | Define default address pools for Docker networks. e.g. base=192.168.0.0/16,size=24 | string | - |
| installDockerBuildx | Install Docker Buildx | boolean | true |
| installDockerComposeSwitch | Install Compose Switch (provided docker compose is available) which is a replacement to the Compose V1 docker-compose (python) executable. It translates the command line into Compose V2 docker compose then runs the latter. | boolean | true |
| disableIp6tables | Disable ip6tables (this option is only applicable for Docker versions 27 and greater) | boolean | false |
| **caCertsMount** | **Automatically mount the dev container's SSL certs into the Buildx/BuildKit builder and propagate proxy variables to support corporate proxies.** | **boolean** | **false** |

## Corporate Proxy & Custom Root CA Support

Standard Docker-in-Docker deployments often fail when running behind a corporate proxy that uses SSL inspection. This occurs because Docker Buildx spins up an isolated `buildkit` container that does not inherit the parent Dev Container's OS-level certificate trust store.

By setting `"caCertsMount": true`, this feature automatically:
1. Creates a persistent Buildx builder named `proxy-builder`.
2. Mounts the Dev Container's SSL certificate directories (`/etc/ssl/certs`, `/usr/local/share/ca-certificates`, etc.) directly into the nested BuildKit container.
3. Automatically passes the parent container's `http_proxy`, `https_proxy`, and `no_proxy` environment variables into the builder.

**Note:** For this to work, your base Dev Container must *already* trust your corporate proxy. (e.g., via Podman global `mounts.conf` injection, or by copying your `.crt` file into the base image via a `Dockerfile` and running `update-ca-certificates`).

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-docker`

## Limitations

This docker-in-docker Dev Container Feature is roughly based on the [official docker-in-docker wrapper script](https://github.com/moby/moby/blob/master/hack/dind) that is part of the [Moby project](https://mobyproject.org/). With this in mind:
* As the name implies, the Feature is expected to work when the host is running Docker (or the OSS Moby container engine it is built on). It may be possible to get running in other container engines, but it has not been tested with them.
* The host and the container must be running on the same chip architecture. You will not be able to use it with an emulated x86 image with Docker Desktop on an Apple Silicon Mac, like in this example:
  ```dockerfile
  FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/typescript-node:16
  ```
  See [Issue #219](https://github.com/devcontainers/features/issues/219) for more details.

## OS Support

This Feature should work on recent versions of Debian/Ubuntu-based distributions with the `apt` package manager installed.

`bash` is required to execute the `install.sh` script.