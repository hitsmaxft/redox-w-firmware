
{ pkgs ? import <nixpkgs> {} }:
let 
  gccarm = pkgs.callPackage ./nix/gccarm6.nix {};

  nrf51-sdk = pkgs.callPackage ./nix/nrfsdk5.nix {};
  run-openocd = pkgs.writeShellApplication {
  name = "openocd-nrf51-stlink";

  runtimeInputs = [ pkgs.openocd ];
  text = ''
    openocd -s ${pkgs.openocd}/share/openocd/scripts  -f interface/stlink.cfg  -f target/nrf51.cfg "${"$"}{@}"
  '';
};
in

pkgs.mkShell {
  name = "nrf51-dev-environment";

  buildInputs = with pkgs; [
    inetutils
    openocd
    cmake
    ninja
    python3 # The nRF tools often require Python
    python312Packages.compiledb
    run-openocd
  ];
  nativeBuildInputs = [
    gccarm
    nrf51-sdk
  ];


  # Set the required environment variables
  shellHook = ''
    # Assuming you have the Nordic nRF51 SDK at this path
    export SDK_ROOT=${nrf51-sdk}/share/nRF5_SDK

    # You may need to adjust or add other environment variables here
    export PATH=$PATH:$NRF_SDK_PATH
    export GNU_INSTALL_ROOT=${gccarm}
    echo "opencod root: ${pkgs.openocd}"
    echo "nRF51 SDK root: $SDK_ROOT"
  '';
}
