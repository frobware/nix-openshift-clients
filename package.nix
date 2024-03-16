{ lib, fetchurl, installShellFiles, stdenv, version, sha256, filename }:

stdenv.mkDerivation rec {
  inherit version sha256 filename;
  name = "${pname}-${version}";
  pname = "oc";
  src = fetchurl {
    url = "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${version}/${filename}.tar.gz";
    sha256 = "${sha256}";
  };

  nativeBuildInputs = [ installShellFiles ];

  phases = " unpackPhase installPhase fixupPhase postInstall ";

  unpackPhase = ''
    runHook preUnpack
    mkdir ${name}
    tar -C ${name} -xzf $src
  '';

  installPhase = ''
    runHook preInstall
    install -D ${name}/oc $out/bin/oc
  '';

  fixupPhase = ''
    if [[ "$(uname -m)" = "x86_64" ]] && [[ "$(uname -s)" = "Linux" ]]; then
      # Adjust the dynamic linker for the pre-built dynamically linked
      # oc binary to ensure compatibility with the Nix environment.
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) $out/bin/oc
    fi
  '';

  postInstall = ''
    $out/bin/oc completion zsh > _oc
    installShellCompletion --zsh --name _oc _oc

    $out/bin/oc completion bash > oc
    installShellCompletion --bash --name oc oc
  '';

  meta = with lib; {
    description = "pre-built OpenShift Client (oc)";
    homepage = "https://github.com/frobware/openshift-clients";
    license = licenses.mit;
    maintainers = with maintainers; [ frobware ];
    mainProgram = "oc";
  };
}
