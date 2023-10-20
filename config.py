import os
import subprocess
import shutil

def can_build(env, platform):
    return shutil.which('cmake') is not None

def configure(env):
    cwd = os.getcwd()
    build_dir = os.path.join(cwd, 'modules/iree/build')
    
    os.makedirs(build_dir, exist_ok=True)
    os.chdir(build_dir)

    parent_dir = os.path.dirname(build_dir)
    subprocess.run(['cmake', parent_dir], check=True)
    subprocess.run(['cmake', '--build', '.'], check=True)