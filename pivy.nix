{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pkgs,
  qtbase,
  qmake,
  soqt,
}:

buildPythonPackage rec {
  pname = "pivy";
  version = "0.6.9pre";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "pivy";
    rev = "931d18f8aa98126f738ff9224ba0ccbd6beed75c";
    hash = "sha256-2TGpu+9c1DQIBsE5OBmW4nRARFiHyGjiWwWvewpAjCg=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = with pkgs; [
    swig
    qmake
    cmake
  ];

  buildInputs =
    with pkgs;
    with xorg;
    [
      coin3d
      soqt
      qtbase
      libGLU
      libGL
      libXi
      libXext
      libSM
      libICE
      libX11
    ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-I${qtbase.dev}/include/QtCore"
    "-I${qtbase.dev}/include/QtGui"
    "-I${qtbase.dev}/include/QtOpenGL"
    "-I${qtbase.dev}/include/QtWidgets"
  ];

  dontUseQmakeConfigure = true;
  dontWrapQtApps = true;
  doCheck = false;

  postPatch = ''
    substituteInPlace distutils_cmake/CMakeLists.txt --replace \$'{SoQt_INCLUDE_DIRS}' \
      \$'{Coin_INCLUDE_DIR}'\;\$'{SoQt_INCLUDE_DIRS}'
  '';

  meta = with lib; {
    homepage = "https://github.com/coin3d/pivy/";
    description = "A Python binding for Coin";
    license = licenses.bsd0;
    maintainers = with maintainers; [ coldelectrons ];
  };
}
