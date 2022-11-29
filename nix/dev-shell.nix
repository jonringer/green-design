{ mkShell
, cargo
}:

mkShell {
  nativeBuildInputs = [ cargo ];
}
