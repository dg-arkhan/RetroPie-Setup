#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="citra"
rp_module_desc="3ds emulator"
rp_module_help="ROM Extensions: .7z .nds .zip\n\nCopy your Nintendo DS roms to $romdir/3ds"
rp_module_licence="GPL2 https://raw.githubusercontent.com/libretro/citra/master/license.txt"
rp_module_section="exp"
rp_module_flags="!gles !arm"

function depends_citra() {
    if compareVersions $__gcc_version lt 7; then
        md_ret_errors+=("Sorry, you need an OS with gcc 7.0 or newer to compile citra")
        return 1
    fi

    # Additional libraries required for running
    local depends=(doxygen qtbase5-dev libqt5opengl5-dev qtmultimedia5-dev build-essential clang libc++-dev cmake)
    getDepends "${depends[@]}"
}

function sources_citra() {
    gitPullOrClone "$md_build" https://github.com/citra-emu/citra.git
}

function build_citra() {
    cd "$md_build/citra"
    mkdir build
    cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$md_inst"
    make
    md_ret_require="$md_build/build/bin/Release/citra"
}

function install_citra() {
    cd build
    make install
}

function configure_citra() {
    mkRomDir "3ds"

    ensureSystemretroconfig "3ds"

    addEmulator 0 "$md_id" "3ds" "$md_inst/bin/citra %ROM%"
    addEmulator 1 "$md_id" "3ds" "$md_inst/bin/citra-qt %ROM%"
    addSystem "3ds"
}
