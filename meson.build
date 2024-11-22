project(
	'valengine',
	'vala', 'c',
	version: '0.1.0',
)

pkg = import('pkgconfig')

# Variables
source_dir = meson.current_source_dir()
vapi_dir = source_dir / 'vapi'
val_source_dir = source_dir / 'src/valengine/'
version = meson.project_version()



image_source_dir = val_source_dir / 'images'
audio_source_dir = val_source_dir / 'audio'
# Install images
install_subdir(
  image_source_dir,
  install_dir: get_option('datadir') / 'valengine'
)


# Install sounds
install_subdir(
  audio_source_dir,
  install_dir: get_option('datadir') / 'valengine'
)


# Compilers
valac = meson.get_compiler('vala')
cc = meson.get_compiler('c')

# Compiler arguments
valac_arguments = [
	'--vapidir', vapi_dir,
	'--debug', 
]

cc_arguments = []

# Debug stuff
if cc.has_argument('-g3')
	cc_arguments += '-g3'
elif cc.has_argument('-g')
	cc_arguments += '-g'
endif

cc_arguments+= '-w'

if cc.has_link_argument('-Wl,--compress-debug-sections=zstd')
	add_project_link_arguments('-Wl,--compress-debug-sections=zstd', language: 'c')
elif cc.has_link_argument('-Wl,--compress-debug-sections=zlib')
	add_project_link_arguments('-Wl,--compress-debug-sections=zlib', language: 'c')
endif

add_project_arguments(valac_arguments, language: 'vala')
add_project_arguments(cc_arguments, language: 'c')

# Dependencies
glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')
raylib_dep = dependency('raylib', fallback: ['raylib', 'raylib_dep'])
gee_dep = dependency('gee-0.8')

project_dependency = [
	glib_dep,
	gobject_dep,
	gio_dep,
	raylib_dep,
	valac.find_library('raylib', required: true, dirs: vapi_dir),
	cc.find_library('m', required: false),
	gee_dep
]
	subdir('src/lib')
	subdir('src/valengine')
	valengine_lib = shared_library(
		'valengine',
		sources: [lib_src, valengine_sources],
		dependencies: project_dependency,
		install: true,
		vala_args: ['--vapi-comments'],
		version: version,
		install_dir: [true, true, true],
	)
	
# pkgconfig
pkg.generate(
	valengine_lib,
	description: 'Valengine: A game engine built with Vala and Raylib.',
	requires: ['raylib'],
)

valengine_dep = declare_dependency(
	link_with: valengine_lib,
	dependencies: project_dependency,
	include_directories: ['.']
)

subdir('src/lib/examples')
subdir('src/valengine/examples')
