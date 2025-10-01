#!/usr/bin/env python

import shutil
import subprocess
import urllib.request
import tempfile
from pathlib import Path
import logging
import zipfile
import os
import sys

logger = logging.getLogger(__name__)


def install_nvim_from_source():
    nvim_version = "0.11.4"
    with tempfile.TemporaryDirectory() as tmpdir:
        logger.info(f"Neovim not installed, installing {nvim_version}...")
        tmppath = Path(tmpdir)
        result = urllib.request.urlretrieve(
            f"https://github.com/neovim/neovim/archive/refs/tags/v{nvim_version}.zip", tmppath / f"{nvim_version}.zip")
        zipfile.ZipFile(f"{nvim_version}.zip", 'r').extractall(tmppath)
        nvim_repo_path = tmppath / f"neovim-{nvim_version}"
        os.chdir(nvim_repo_path)
        compile_nvim = subprocess.run(
            ['make CMAKE_BUILD_TYPE=RelWithDebInfo'], shell=True)
        if compile_nvim.returncode != 0:
            logger.info('Neovim installation failed')
            sys.exit(1)
        logger.info('Provide password...')
        subprocess.run(
            ['sudo', 'make', 'install'], shell=True)


def install_nvim():
    # Check if Neovim is installed
    if subprocess.run(['which', 'nvim']).returncode == 1:
        install_nvim_from_source()


def main():
    pass


if __name__ == '__main__':
    main()
