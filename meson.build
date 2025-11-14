project('synaTudor', ['c'],
    version: '1.0.0',
    meson_version: '>= 0.57.0'
)

INSTALL_DIR = get_option('install_dir')

# Add gio-unix-2.0 for gunixfdmessage.h
gio_unix_dep = dependency('gio-unix-2.0')

# Find libfprint-tod dependency
libfprint_tod_dep = dependency('libfprint-2-tod-1')

# Add parent libfprint-2 directory for fp-image.h
libfprint_tod_inc = include_directories(
    libfprint_tod_dep.get_variable(pkgconfig: 'includedir') + '/libfprint-2'
)

subdir('libtudor')
subdir('cli')
subdir('tudor-host')
subdir('tudor-host-launcher')
subdir('libfprint-tod')
