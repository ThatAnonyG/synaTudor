#!/bin/bash -e

HASH_FILE="$1"
INSTALLER_EXE="$2"
TMP_DIR="$3"
OUT_DIR="$4"
DLLS=${@:5}

mkdir -p "$TMP_DIR"

#Download the driver executable and check hash
INSTALLER="$TMP_DIR/installer.exe"
cp "$INSTALLER_EXE" "$INSTALLER"
shasum "$INSTALLER" | cut -d" " -f1 | cmp - "$HASH_FILE"

#Extract the driver
WINDRV="$TMP_DIR/windrv"
mkdir -p "$WINDRV"
innoextract -d "$WINDRV" "$INSTALLER"

#Copy outputs
mkdir -p "$OUT_DIR"
for dll in $DLLS; do
	cp $(find "$WINDRV" -name "$dll") "$OUT_DIR/$dll"
done
