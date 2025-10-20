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
        "4.13.38" = {
          sha256 = {
            aarch64-darwin = "sha256-8fjZx5kpjC7Gyz+cGXrnucrLpLucCB49QoTQwAD05vY=";
            aarch64-linux = "sha256-VtT6F/VsVA/tWTL3MdH/+Nn/sd3PosTkJCyWSpqZMjc=";
            x86_64-darwin = "sha256-xSrRiLAlqzPUtNjPkqNYvkHh5Ol5yvYc7PdXxunXjHw=";
            x86_64-linux = "sha256-UXgqZwzOGmzDc5h1gHpB56nP5OEmyl21SgV20hzvE3c=";
          };
        };
        "4.14.18" = {
          sha256 = {
            aarch64-darwin = "sha256-4S9+/wxDX8eEqtsQAt5Bq3yCAf/P5RkhI/Dd2vr1Mqo=";
            aarch64-linux = "sha256-UVqUvCSRkmjNGczPBH2bforTPWaSAf72Xuqu3hAeHWM=";
            x86_64-darwin = "sha256-CFnQAmg+AR+tk6+Nl8uN+49dXa9rTJWYmvAlly52AN8=";
            x86_64-linux = "sha256-xhSF8e44Pf0ahFMl59QtYVga0LP6tGfRTC/owUTJF48=";          };
        };
        "4.15.20" = {
          sha256 = {
            aarch64-darwin = "sha256-tEnxLHiKkZ0Rwi2gqWL2oWbUAeFoPNdtomJh4ANUoCg=";
            aarch64-linux = "sha256-1EVBpsIT4526GYHoUi4YipyJgEjzng29SFxNO0PbNZk=";
            x86_64-darwin = "sha256-r1L/12Uwp8Se27UEJAQLrHE2KqoJ0VX74lZ8nRIBq/s=";
            x86_64-linux = "sha256-J8eGdctm3FwUGzdK/iYm/baPSLB2+RSnPsuApJGDhJk=";            
          };
        };
        "4.16.26" = {
          sha256 = {
            aarch64-darwin = "sha256-ll+eVFG89Pc2w/hbu9j7kv1kjuSaGu5stFPDAc5QQ+4=";
            aarch64-linux = "sha256-2TpCMf+v/ciQaj2pyAV9oajCN7GGj30FidOkKRpsEeY=";
            x86_64-darwin = "sha256-MXC0Npf9KtRhbZPmauABE3NSv+H3Pm37Aceax4Aq8iQ=";
            x86_64-linux = "sha256-sKffDVPnju6sia8kW4i6j3K1z0SQqJzqF/ElLHb01vY=";
          };
        };
        "4.17.8" = {
          sha256 = {
            aarch64-darwin = "sha256-1V89V2ffYrgL6CPblMmGFPhwpBF7ij5CL8+Wq4TIfQc=";
            aarch64-linux = "sha256-dL4tQKq/rFc2/3hKMJ9w444MtBM7wcGYvX7ReRNO+Uk=";
            x86_64-darwin = "sha256-NC497vgkURT5iKggXctvUhJ+c52ibiViNSTxl4NYHOg=";
            x86_64-linux = "sha256-8txV4C5Tu2FA1sec50tm9oX3T0jdPzaLLN42dKRxAYU=";          };
        };
        "4.19.16" = {
          sha256 = {
            aarch64-darwin = "sha256-nc0zRGv+gfLWpnqL4ONeO90mscvj2wh0VovyVUp7FIc=";
            aarch64-linux = "sha256-YzVDFkCaHJyn3hb8fILxI/LFQ/iKxw3JlVb/WkEtj7E=";
            x86_64-darwin = "sha256-sHWCGJiwGD7764n4OKdkYuw4JGaaoRWgiU6FXRtywnc=";
            x86_64-linux = "sha256-r0r6gL4xZxmU3dwtZIeYWvllomLVoTBnAd5G20Tw0vQ=";
          };
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
      oc = final.oc_4_19;
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
      oc_4_16 = pkgs.oc_4_16;
      oc_4_17 = pkgs.oc_4_17;
      oc_4_19 = pkgs.oc_4_19;
    });
  };
}
