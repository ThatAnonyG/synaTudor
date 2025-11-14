{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  glib,
  libusb1,
  libgusb,
  json-glib,
  libfprint-tod,
  innoextract,
  wget,
}:
stdenv.mkDerivation {
  pname = "synaTudor";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ThatAnonyG";
    repo = "synaTudor";
    rev = "b93c848092f7e668c926ad7c19b4ecf2bf3f76c5"; # pick a commit
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    innoextract
    wget
  ];

  buildInputs = [
    glib
    libusb1
    libgusb
    json-glib
    libfprint-tod
  ];

  # Patch meson.build to fix include paths
  postPatch = ''
    # The include directory path needs to be available at build time
    substituteInPlace libfprint-tod/meson.build \
      --replace "install_dir: libfprint_tod_dep.get_variable(pkgconfig: 'tod_driversdir')" \
                "install_dir: '${libfprint-tod}/lib/libfprint-2/tod-1'"
  '';

  mesonFlags = [
    "-Dinstall_dir=${placeholder "out"}/sbin/tudor"
  ];

  meta = with lib; {
    description = "Synaptics Tudor fingerprint driver";
    homepage = "https://github.com/your-repo/synaTudor";
    license = licenses.unfree; # Adjust based on your license
    platforms = platforms.linux;
    maintainers = [];
  };
}
