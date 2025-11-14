{
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  # xdg-utils,
  ...
}:
stdenvNoCC.mkDerivation rec {
  name = "multiviewer";
  version = "2.3.0";

  src = fetchzip {
    url = "https://releases.multiviewer.app/download/305607200/MultiViewer-linux-x64-2.3.0.zip";
    hash = "sha256-NeMp4i0GbwgxUPna9IazIrW/BLAOjIclc97ufLx4Zxw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  # buildInputs = [ xdg-utils ];
  desktopItem = makeDesktopItem {
    name = "multiviewer";
    exec = "multiviewer %U";
    icon = "multiviewer";
    desktopName = "MultiViewer";
  };

  installPhase = ''
    install -Dm0644 {${desktopItem},$out}/share/applications/multiviewer.desktop
    mkdir -p $out/bin/
    ln -s $src/multiviewer $out/bin/multiviewer
  '';

  # https://github.com/f1multiviewer/issue-tracker/issues/506
  # add no-sandbox flag?
  postFixup = ''
    runHook preInstall

    wrapProgram $out/bin/multiviewer \
      --add-flags "--no-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations}}" \

    runHook postInstall
  '';
}
