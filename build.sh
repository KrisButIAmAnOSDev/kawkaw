#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

export THEOS="${THEOS:-$PWD/theos}"

rm -rf build
mkdir -p build

echo "[*] Building kawkaw..."
make clean
make

echo "[*] Packaging IPA..."
mkdir -p build/Payload
# Package from the MERGED bundle path (contains Info.plist), not the arch-specific one
cp -r .theos/obj/debug/kawkaw.app build/Payload/
rm -rf build/Payload/kawkaw.app/kawkaw.dSYM
cd build && zip -qr kawkaw.ipa Payload

echo "[+] IPA at build/kawkaw.ipa"
ls -la build/kawkaw.ipa
