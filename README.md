# README.md

## Overview

This repository hosts a Nix flake that provides multiple versions of
the OpenShift client (`oc`). It is designed to offer flexibility for
developers and systems administrators who need specific versions of
`oc` across different platforms including `aarch64-darwin`,
`aarch64-linux`, `x86_64-darwin`, and `x86_64-linux`.

## Features

- **Multiple Versions**: Supports OpenShift client versions `4.10.67`,
  `4.11.58`, `4.12.49`, `4.13.33`, and `4.14.12`.
- **Cross-Platform**: Available for both Linux and macOS, including
  ARM64 architectures.
- **Convenience**: Includes an `oc-meta` package that installs
  symlinks for all provided `oc` versions and Zsh completions.

## Requirements

- Nix with flake support.

## Usage

To use this flake, you can add it to your `flake.nix` with:

```nix
{
  inputs.openshift-client-flake.url = "github:<your-username>/<your-repo>";
}
```

Then, you can use the packages or overlays provided by this flake. For
example, to install a specific version of the OpenShift client, you
can add the following to your environment:

```nix
{
  environment.systemPackages = with pkgs; [
    openshift-client-flake.packages.x86_64-linux.oc_4_14
  ];
}
```

### Available Commands

Once installed, the `oc` versions are accessible through versioned
commands, e.g., `oc-4.14`, `oc-4.10`, etc. The `oc-meta` package also
installs a `_oc` completion script for Zsh users.

### Development Shell

A development shell is included for each supported system. It provides
`nix` and `nix-prefetch` for easy development and testing of the
flake. To enter the development shell, run:

```bash
nix develop
```

## Contributing

Contributions are welcome! If you would like to add more versions or
improve the flake, please submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
