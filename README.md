# ersatztv-flake

[![Nix](https://img.shields.io/badge/built_with-Nix-5277C3?logo=nixos\&logoColor=white)](https://nixos.org)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![ErsatzTV](https://img.shields.io/badge/upstream-ErsatzTV-orange)](https://ersatztv.org)

A Nix flake that provides a package and (WIP) module for [ErsatzTV](https://ersatztv.org). ErsatzTV lets you stream custom live channels using your own media library.

## Features

* Nix package for `ersatztv`
* (WIP) NixOS module for easy service configuration

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
          services.ersatztv.enable = true;
        }
      ];
    };
  };
}
```

## About ErsatzTV

ErsatzTV can:

* Use local files or connect to media servers (Plex, Jellyfin, Emby)
* Provide IPTV and HDHomeRun emulation
* Offer channel-specific transcoding and scheduling options

Learn more at [ersatztv.org](https://ersatztv.org).

## License

* **ersatztv-flake** is licensed under the [MIT License](LICENSE).
* **ErsatzTV** is licensed under the [zlib License](https://github.com/ErsatzTV/ErsatzTV/blob/main/LICENSE).