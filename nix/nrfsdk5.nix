{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "nrf51-sdk";
  version = "11.0.0";
  urlHash = "89a8197";


  src = fetchzip {
    url = "https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v11.x.x/nRF5_SDK_${version}_${urlHash}.zip";
    sha256 = "sha256-PGi0caanV4tG+UJYOhZeeoD0/1t2f+4MtUxjFtd7sYg=";
    stripRoot=false;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/nRF5_SDK
    sed -i "s/:=/?=/" components/toolchain/gcc/Makefile.posix
    cat components/toolchain/gcc/Makefile.posix
    mv * $out/share/nRF5_SDK
    rm $out/share/nRF5_SDK/*.msi

    runHook postInstall
  '';

  meta = with lib; {
    description = "Nordic Semiconductor nRF5 Software Development Kit";
    homepage = "https://www.nordicsemi.com/Products/Development-software/nRF5-SDK";
    license = licenses.unfree;
    platforms = platforms.all;
    maintainers = with maintainers; [ stargate01 ];
  };
}
