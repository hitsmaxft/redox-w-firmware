
{ pkgs ? import <nixpkgs> {} }:
let 
  gccarm = pkgs.callPackage ./nix/gccarm6.nix {};

  nrf51-sdk = pkgs.callPackage ./nix/nrfsdk5.nix {};
in

pkgs.mkShell {
  name = "nrf51-dev-environment";

  buildInputs = with pkgs; [
    openocd
    cmake
    ninja
    python3 # The nRF tools often require Python
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
    echo "nRF51 SDK root: $SDK_ROOT"
  '';
}
