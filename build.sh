#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

THEOS="/home/quan/ralsei/0xyt0c1n/theos"

rm -rf build
mkdir -p build

echo "[*] Building kawkaw..."
make clean THEOS="$THEOS"
make THEOS="$THEOS"

echo "[*] Packaging IPA..."
mkdir -p build/Payload
cp -r .theos/obj/debug/kawkaw.app build/Payload/
rm -rf build/Payload/kawkaw.app/kawkaw.dSYM
(cd build && zip -qr kawkaw.ipa Payload)

echo "[+] IPA at build/kawkaw.ipa"
ls -la build/kawkaw.ipa
