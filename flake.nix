{
  description = "A flake providing multiple versions of the OpenShift client (oc).";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: let
    forAllSystems = function: nixpkgs.lib.genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ] (
      system: function system
    );

    ocOverlay = final: prev: let
      buildOpenShiftClientVersionFor = system: version: sha256: filename: prev.callPackage ./package.nix {
        inherit version sha256 filename;
      };

      versions = {
        "4.10.67" = {
          sha256 = {
            aarch64-darwin = "sha256-b5KfpzqOjVH1Z3I47Ky7wFLYYTIHwDGpWxajA1FeOoY=";
            aarch64-linux = "sha256-v33n+cBiV26vFUL0+rbRR/HGtqII/sr0HDH7mUds8j8=";
            x86_64-darwin = "sha256-C2z1bVgD0+aIg4a9C+XCBRkMXU7hdQ8VO336/FuBf3A=";
            x86_64-linux = "sha256-WBec6o+EWLyqMBspI/DuKVxEzkVK7vs0Zi+KR4lZP3Y=";
          };
        };
        "4.11.58" = {
          sha256 = {
            aarch64-darwin = "sha256-CSj4JqOWntxJDHxUVMH6SmREhlvPK0esVRbvLqCrLpg=";
            aarch64-linux = "sha256-at3wLmYBmT4jqS6ENrJSwh6O9AGQipPVm2SI5vjnc6Q=";
            x86_64-darwin = "sha256-sV1v6NEc2Ec8FZA4CNxfv4FZuGNS4HqqtgT1UR1lSB8=";
            x86_64-linux = "sha256-gL7nAmNta9hJ6nuA69fTCkSLWJI8GKRehMHz59Edcis=";
          };
        };
        "4.12.49" = {
          sha256 = {
            aarch64-darwin = "sha256-dqCmMaJTMKFRQ7bwKc9fRB3l3xXUQEdNbbZt4GzU9GI=";
            aarch64-linux = "sha256-65vNTUH55T7tkhJ4WZUYGfsxqL6LfsiIxpBSQ5XDcGg=";
            x86_64-darwin = "sha256-Q1SvWNofHq1gfSNrk7UKo+p5XjC3Tw6UTUYtOFphMfM=";
            x86_64-linux = "sha256-s/aGAzNIi0/puliwCal++VOqaygdwkJSB1hXcnPGypg=";
          };
        };
        "4.13.33" = {
          sha256 = {
            aarch64-darwin = "sha256-/Rfz8xppCv7srXPqEiJZqlrwvxljgT3r3zwCFdY+g/E=";
            aarch64-linux = "sha256-pqFMz+Z0n1OFWm3bE3GUd8qj05IP8VZVYNKOVey+Z34=";
            x86_64-darwin = "sha256-z27LquIjm5V0aazHuw++pv97Nmd1HlAicLhG7oU37+Y=";
            x86_64-linux = "sha256-jAkWqHs36ojHEUdrd0wsxroYZKmuh3H+1abhfj+2ris=";
          };
        };
        "4.14.12" = {
          sha256 = {
            aarch64-darwin = "sha256-oUCds9jCbUTuPCQPeyMFUGODvjy38I5bocoh7AVGwe0=";
            aarch64-linux = "sha256-18lqZ+d/bnFqZv10B84EsvmzfveQK4XeaML4RvV8BOA=";
            x86_64-darwin = "sha256-KoD/9lsE3kuJl96k3BYVAjeJIESQW2zRO1RjTPsqSQ8=";
            x86_64-linux = "sha256-4hLzoXJnkIo7yYRwnWp15x5hviVz8JNfO92d08Kv89I=";
          };
        };
        "4.15.5" = {
          sha256 = {
            aarch64-darwin = "sha256-NydiNyGY2VuK7vLr5XDBVKtqs2XrDTBMD+xorIZkmOY=";
            aarch64-linux = "sha256-O0aA4OVSyc4GBBd3hvrdKR5wSDrfrY+E24kXpU4+CzA=";
            x86_64-darwin = "sha256-MAIzyrNRSuxKD2Lqfe5kL5+WO/r7VE353ufksfuwdwA=";
            x86_64-linux = "sha256-DSv8906B4iOAjCAHr3J7WYCw49GQufC5TGoERpIntm8=";          };
        };
      };

      systemFilenameMap = {
        x86_64-linux = "openshift-client-linux";
        aarch64-linux = "openshift-client-linux-arm64";
        x86_64-darwin = "openshift-client-mac";
        aarch64-darwin = "openshift-client-mac-arm64";
      };

      ocPackages = builtins.listToAttrs (nixpkgs.lib.mapAttrsToList (version: versionData: {
        name = "oc_${builtins.replaceStrings ["."] ["_"] "${prev.lib.versions.majorMinor version}" }";
        value = buildOpenShiftClientVersionFor prev.system version versionData.sha256.${prev.system} systemFilenameMap.${prev.system};
      }) versions);

      versionsList = builtins.attrNames versions;

      ocMetaPackage = prev.stdenv.mkDerivation rec {
        name = "oc-meta";
        pname = "oc-meta";
        buildInputs = [ prev.makeWrapper prev.installShellFiles ];
        buildCommand = let
          versionedCommands = builtins.concatStringsSep " " (map (version: "oc-${prev.lib.versions.majorMinor version}") versionsList);
          compdefs = "compdef _oc " + versionedCommands + "\n";
        in ''
          mkdir -p $out/bin

          # Create symlink for oc binaries
          ${builtins.concatStringsSep "\n" (map (version: let
            versionedName = "oc_${builtins.replaceStrings ["."] ["_"] "${final.lib.versions.majorMinor version}"}";
            binaryPath = "${ocPackages.${versionedName}}/bin/oc";
          in ''
            ln -s ${binaryPath} $out/bin/oc-"${prev.lib.versions.majorMinor version}"
          '') versionsList)}

          echo "#${compdefs}" > _${name}
          echo "${compdefs}" >> _${name}
          installShellCompletion --zsh --name _${name} _${name}
        '';
      };
    in ocPackages // {
      oc-meta = ocMetaPackage;
      oc = final.oc_4_15;
    };
  in {
    checks = forAllSystems (system: {
      build = self.packages.${system}.default;
    });

    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages."${system}";
    in {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.nix
          pkgs.nix-prefetch
        ];
        packages = [
          (pkgs.writeScriptBin "fetch-hash" (builtins.readFile ./fetch-hash.sh))
        ];
        shellHook = ''
          # Setting NIX_PATH explicitly so that nix-prefetch-url can
          # find the nixpkgs location. This is essential because a
          # pure shell does not inherit NIX_PATH from the parent
          # environment.
          export NIX_PATH=nixpkgs=${pkgs.path}
        '';
      };
    });

    overlays = {
      default = ocOverlay;
    };

    packages = forAllSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlays.default ];
      };
    in {
      default = pkgs.oc;
      oc = pkgs.oc;
      oc-meta = pkgs.oc-meta;
      oc_4_10 = pkgs.oc_4_10;
      oc_4_11 = pkgs.oc_4_11;
      oc_4_12 = pkgs.oc_4_12;
      oc_4_13 = pkgs.oc_4_13;
      oc_4_14 = pkgs.oc_4_14;
      oc_4_15 = pkgs.oc_4_15;
    });
  };
}
