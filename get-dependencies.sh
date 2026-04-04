#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake         \
    gtkmm3        \
    libhandy      \
    libsodium     \
    nlohmann-json \
    rnnoise       \
    spdlog

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building stable version of Abaddon..."
echo "---------------------------------------------------------------"
REPO="https://github.com/uowuo/abaddon"
VERSION="$(curl -s https://api.github.com/repos/uowuo/abaddon/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | sed 's/^v//')"
git clone --recursive --depth 1 -b "v$VERSION" "$REPO" ./abaddon
echo "$VERSION" > ~/version

cmake -B build -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -S ./abaddon
cmake --build build -j$(nproc)
cmake --install build
