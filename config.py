import shutil

def can_build(env, platform):
    return shutil.which('cmake') is not None

def configure(env):
    pass