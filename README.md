# ersatztv-flake

[![Nix](https://img.shields.io/badge/built_with-Nix-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![ErsatzTV](https://img.shields.io/badge/upstream-ErsatzTV-orange)](https://ersatztv.org)

A Nix flake that provides a package and NixOS module for [ErsatzTV](https://ersatztv.org). ErsatzTV lets you stream custom live channels using your own media library.

## Features

* Nix package for `ersatztv`
* NixOS module for easy service configuration
* Configurable bind mounts for media directories

## Usage

### As a package

```bash
nix run github:noblepayne/ersatztv-flake
```

### As a NixOS module

In your `flake.nix`:

```nix
{
  inputs.ersatztv-flake.url = "github:noblepayne/ersatztv-flake";
  
  outputs = { self, nixpkgs, ersatztv-flake, ... }: {
    nixosConfigurations.my-server = nixpkgs.lib.nixosSystem {
      modules = [
        ersatztv-flake.nixosModules.default
        {
          services.ersatztv = {
            enable = true;
            bindReadOnlyPaths = [
              "/home/user/Videos:/media/Videos"
              "/mnt/storage/Movies:/media/Movies"
              "/mnt/storage/TV:/media/TV"
            ];
          };
        }
      ];
    };
  };
}
```

## Configuration Options

The NixOS module supports the following options:

* `enable` - Enable the ErsatzTV service
* `uiPort` / `streamingPort` - Configure ports (default: 8409)
* `bindReadOnlyPaths` - Mount media directories into the service
* `enableFonts` - Install subtitle fonts (default: true)
* `user` / `group` - Service user configuration (default: ersatztv)
* `extraEnvironment` - Additional environment variables

See the module source for complete option documentation.

## About ErsatzTV

ErsatzTV can:

* Use local files or connect to media servers (Plex, Jellyfin, Emby)
* Provide IPTV and HDHomeRun emulation
* Offer channel-specific transcoding and scheduling options

Learn more at [ersatztv.org](https://ersatztv.org).

## License

* **ersatztv-flake** is licensed under the [MIT License](LICENSE).
* **ErsatzTV** is licensed under the [zlib License](https://github.com/ErsatzTV/ErsatzTV/blob/main/LICENSE).

## TODO:
- Investigate [Scripted Schedules api client](https://github.com/ErsatzTV/ErsatzTV/blob/main/docker/Dockerfile#L11-L18)
- Investigate custom ffmpeg and other options for acceleration
- Passthru update script

## Updating nuget deps:
You'll need nix installed, then run

```sh
./update-deps.sh
```
