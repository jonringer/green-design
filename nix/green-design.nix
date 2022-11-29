{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "green-design";
  version = "0.0.1";

  src = ../..;

  cargoLock.lockFile = ../Cargo.lock;

  meta = with lib; {
    description = "Tool for designing and planning gardens, farms, and landscapes";
    homepage = "https://github.com/jonringer/green-design";
    license = licenses.asl20;
    maintainers = with maintainers; [ jonringer ];
  };
}
