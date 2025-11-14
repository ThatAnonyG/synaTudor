{
  lib,
  stdenv,
  meson,
  ninja,
  pkg-config,
  glib,
  glibc,
  gcc,
  libusb1,
  gusb,
  libjson,
  libfprint,
  libfprint-tod,
  innoextract,
  openssl,
  libcap,
  libseccomp,
  dbus,
  wget,
  cmake,
  perl,
}:
stdenv.mkDerivation {
  pname = "synaTudor";
  version = "1.0.0";

  src = ./.; # Use current directory, or use fetchFromGitHub for remote repo

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    meson
    ninja
    innoextract
    wget
    glib
    glibc
    gcc
    libusb1
    gusb
    libjson
    libfprint
    libfprint-tod
    openssl
    libcap
    libseccomp
    dbus
    cmake
    perl
  ];

  # Patch meson.build to fix include paths
  postPatch = ''
    substituteInPlace libfprint-tod/meson.build \
      --replace "install_dir: libfprint_tod_dep.get_variable(pkgconfig: 'tod_driversdir')" \
                "install_dir: '${placeholder "out"}/lib/libfprint-2/tod-1'"

    substituteInPlace tudor-host-launcher/meson.build \
      --replace "install_dir: '/usr/lib/systemd/system/'" \
                "install_dir: '${placeholder "out"}/lib/systemd/system/'"

    substituteInPlace tudor-host-launcher/meson.build \
      --replace "install_dir: dbus_dep.get_variable(pkgconfig: 'datadir') / 'dbus-1/system.d'" \
                "install_dir: '${placeholder "out"}/etc/dbus-1/system.d'"

    substituteInPlace tudor-host-launcher/meson.build \
      --replace "install_dir: dbus_dep.get_variable(pkgconfig: 'system_bus_services_dir')" \
                "install_dir: '${placeholder "out"}/etc/dbus-1/system-services'"

    substituteInPlace libfprint-tod/meson.build \
      --replace "install_dir: udev_dep.get_variable(pkgconfig: 'udevdir')" \
                "install_dir: '${placeholder "out"}/lib/udev/rules.d/'"
  '';

  mesonFlags = [
    "-Dinstall_dir=${placeholder "out"}/sbin/tudor"
  ];

  passthru.driverPath = "/lib/libfprint-2/tod-1";

  meta = with lib; {
    description = "Synaptics Tudor fingerprint driver";
    homepage = "https://github.com/your-repo/synaTudor";
    license = licenses.free; # Adjust based on your license
    platforms = platforms.linux;
    maintainers = [];
  };
}
