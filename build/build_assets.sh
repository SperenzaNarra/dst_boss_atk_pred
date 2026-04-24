#!/bin/bash

set -ex

REPO="$PWD"

apk add xvfb-run gimp python3 py3-pillow optipng

pushd xcf

for DIR in *; do
  echo "$DIR"
  xvfb-run gimp -n -i --batch-interpreter python-fu-eval --quit -b - <<EOF
import glob

for file in glob.glob("${DIR}/*.xcf"):
  img = Gimp.file_load(Gimp.RunMode.NONINTERACTIVE, Gio.File.new_for_path(file))
  img.scale(128, 128)
  img.merge_visible_layers(Gimp.MergeType.CLIP_TO_IMAGE)
  filename = file[:-4] + ".png"
  Gimp.file_save(Gimp.RunMode.NONINTERACTIVE, img, Gio.File.new_for_path(filename))
  img.delete()
EOF
done

for FILE in */*.png; do
  # GIMP-generated PNG files contain time in metadata, but git doesn't play
  # nicely if files inside are non-deterministic.
  optipng -strip all "$FILE"

  "${REPO}/build/mod_tools/png" "$FILE" unused_arg
done

for FILE in */*.tex */*.xml; do
  mv "$FILE" ../dist/images/"$FILE"
done
