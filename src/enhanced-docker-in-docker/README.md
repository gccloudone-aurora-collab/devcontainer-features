
# Enhanced Docker (Docker-in-Docker) (enhanced-docker-in-docker)

Create child containers *inside* a container, independent from the host's docker instance. Installs Docker extension in the container along with needed CLIs.

## Example Usage

```json
"features": {
    "ghcr.io/KingBain/devcontainer-features/enhanced-docker-in-docker:1": {}
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
| caCertsMount | Automatically mount the dev container's SSL certs into the Buildx/BuildKit builder to support corporate proxies. | boolean | false |

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-docker`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/KingBain/devcontainer-features/blob/main/src/enhanced-docker-in-docker/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
