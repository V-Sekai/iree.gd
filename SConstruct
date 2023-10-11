import os

# Project configuration
project_name = 'iree-gd'
version = '0.0.1'
languages = ['CXX', 'C']

# System packages and programs
python_found = os.system('which python') == 0

# Options
options = {
    'ENABLE_ASAN': False,
    'IREE_BUILD_COMPILER': False,
    'IREE_BUILD_TESTS': False,
    'IREE_BUILD_SAMPLES': True,
    'IREE_BUILD_BUNDLED_LLVM': False,
    'IREE_HAL_DRIVER_LOCAL_SYNC': True,
    'IREE_HAL_DRIVER_LOCAL_TASK': True,
    'IREE_HAL_EXECUTABLE_LOADER_VMVX_MODULE': True,
    'IREE_HAL_DRIVER_VULKAN_DEFAULT': True,
    'IREE_HAL_DRIVER_METAL_DEFAULT': False,
    'IREE_ENABLE_THREADING': True,
}

# Project-wide properties
src_dir = '#src'
sample_dir = '#sample'
thirdparty_dir = '#thirdparty'

env = Environment(ENV=os.environ)

# Set the C++ standard
env.Append(CXXFLAGS=['-std=c++20'])

iree_include_dir = [os.path.join(thirdparty_dir, 'iree', 'runtime', 'src'), os.path.join(thirdparty_dir, 'iree')]
godot_cpp_include_dir = [os.path.join(thirdparty_dir, 'godot-cpp', 'gen', 'include'),
os.path.join(thirdparty_dir, 'godot-cpp', 'include'),
os.path.join(thirdparty_dir, 'godot-cpp', 'gdextension'),
]
env.Append(CPPPATH=[src_dir, thirdparty_dir, iree_include_dir, godot_cpp_include_dir])

# `godot-cpp`
godot_compile_flags = []
godot_linker_flags = []

if env['CC'] == 'cl':
    # using Visual Studio C++
    godot_compile_flags.extend(['/EHsc', '/WX', '/DTYPED_METHOD_BIND'])
    if env['variant'] == 'debug':
        godot_compile_flags.append('/MDd')
    else:
        godot_compile_flags.append('/MD')
    godot_compile_flags.extend(['/wd4244', '/wd4305', '/wd4101', '/wd4018', '/wd4267'])
else:
    if not env['PLATFORM'] == 'darwin':
        godot_linker_flags.append('-static-libgcc -static-libstdc++ -Wl,-R,\'$$ORIGIN\'')
    godot_compile_flags.extend(['-fPIC', '-g', '-Wwrite-strings'])

# Synchronized with godot-cpp's SConscript
bits = 64

godot_cpp_build_type = 'Debug'
system_name = env['PLATFORM'].lower()
build_type = godot_cpp_build_type.lower()

iree_build_dir = '#build/iree'
godot_cpp_build_dir = '#build/godot-cpp'

cmake_command = 'cmake $SOURCE -B $TARGET && cmake --build $TARGET'
for option, value in options.items():
    cmake_command += f' -D{option}={str(value).upper()}'

iree_cmake_cache = env.Command(
    target=os.path.join(iree_build_dir, 'build'),
    source=os.path.join(thirdparty_dir, 'iree', 'CMakeLists.txt'),
    action=cmake_command
)

godot_cpp_build_command = 'scons'
godot_cpp_all = env.Command(
    target='thirdparty/godot-cpp',
    source='thirdparty/godot-cpp',
    action=godot_cpp_build_command
)

# Make godot_cpp_all depend on iree_make instead of iree_cmake_cache
Depends(godot_cpp_all, iree_cmake_cache)

srcs = Glob(os.path.join(src_dir, '*.cpp'))

lib = env.SharedLibrary(source=srcs)

env.Command(
    target=os.path.join(sample_dir, 'extensions', 'iree-gd', lib[0].name),
    source=lib,
    action=Copy("$TARGET", "$SOURCE")
)

godot_cpp_lib_path = os.path.join(thirdparty_dir, 'godot-cpp', 'bin')
godot_cpp_lib = os.path.join(godot_cpp_lib_path, 'libgodot-cpp.macos.template_debug.universal.a')

env.Append(LIBPATH=[godot_cpp_lib_path])

env.Append(LIBS=['godot-cpp.macos.template_debug.universal'])